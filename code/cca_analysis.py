#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from pathlib import Path
import numpy as np
import pandas as pd
import polars as pl
import polars.selectors as cs
import matplotlib.pyplot as plt

from paths import PROJECT_DIR

# canonical correlations between text (Z_X, covariates) and image (Z_W, instruments)
# Meza & Singh (2025), "Canonical correlation regression with noisy data", sec 3.1, Example 2:
#
#   Z_X = U S V'          SVD of noisy covariates,  keep top k left singular vectors -> U_k
#   Z_W = U~ S~ V~'       SVD of noisy instruments, keep top l left singular vectors -> U~_l
#   canonical correlations = singular values of U~_l' U_k
#
# blocks are centered before the SVD (not in the paper, whose simulated data are mean zero).
# without it the first left singular vector of each block is the constant vector and rho_1 = 1.

#----- Load embeddings

# 21,560 rows = 1,540 products x 14 periods; embeddings are the same in every period
# so keep period 0 -> one row per product

image = pl.read_parquet(PROJECT_DIR / "data/embeddings/image_embeddings.parquet")
text = pl.read_parquet(PROJECT_DIR / "data/embeddings/text_embeddings.parquet")

first = (text["period"] == 0).to_numpy()

Z_W = image.select(cs.starts_with("image_")).to_numpy()[first]   # 1540 x 768
Z_X = text.select(cs.starts_with("text_")).to_numpy()[first]     # 1540 x 768

#----- CCA

# k = rank kept for X, l = rank kept for W
KL_CHOICES = [(1, 3), (2, 6), (3, 9)]
# all combinations instead:
# KL_CHOICES = [(k, l) for k in [1, 2, 3] for l in [3, 4, 5, 6]]
N_PAIRS = 3

# "text": X = text, W = image.  "image": X = image, W = text.
X_BLOCK = "image"
if X_BLOCK == "image":
    Z_X, Z_W = Z_W, Z_X

# subtract column means before the SVD
CENTER = False
if CENTER:
    Z_X = Z_X - Z_X.mean(axis=0)
    Z_W = Z_W - Z_W.mean(axis=0)

U, S, Vt = np.linalg.svd(Z_X, full_matrices=False)
U_t, S_t, Vt_t = np.linalg.svd(Z_W, full_matrices=False)

rows = {}
for k, l in KL_CHOICES:
    rho = np.linalg.svd(U_t[:, :l].T @ U[:, :k], compute_uv=False)   # min(k, l) values
    n = min(N_PAIRS, k, l)
    rows[f"k{k}_l{l}"] = np.r_[rho[:n], np.full(N_PAIRS - n, np.nan)]

canonical_corrs = pd.DataFrame(rows)
canonical_corrs.insert(0, "pair", np.arange(1, N_PAIRS + 1))

#----- Save canonical correlations

canonical_corrs.to_csv(
    PROJECT_DIR / "data/spectral/canonical_correlations.csv",
    index = False
)

#----- Plot

plt.figure(figsize=(8, 5))
for k, l in KL_CHOICES:
    plt.plot(canonical_corrs["pair"], canonical_corrs[f"k{k}_l{l}"], marker="o", markersize=3, label=f"k={k}, l={l}")
plt.xlabel("Canonical pair")
plt.ylabel("Canonical correlation")
plt.title(f"Canonical correlations, X = {X_BLOCK}, W = {'image' if X_BLOCK == 'text' else 'text'}")
plt.xticks(canonical_corrs["pair"])
plt.ylim(0, 1)
plt.legend()
plt.tight_layout()

#----- Save plot

plt.savefig(PROJECT_DIR / "figures/cca_canonical_correlations.png", dpi=150)
