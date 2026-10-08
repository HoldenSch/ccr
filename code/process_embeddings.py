#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# in addition to requirements.txt, set up a venv that 
# has sklearn, polars, pandas, pathlib, pyarrow

from pathlib import Path
import pandas as pd
import numpy as np 
import polars as pl
import polars.selectors as cs
import pyarrow as pa 
import sklearn as sk
from sklearn.cross_decomposition import CCA

from paths import PROJECT_DIR 

# there are 21,560 rows for each embedding file (1,540 products × 14 periods = 21,560 rows)

# image = 773 columns 
image = pl.read_parquet(PROJECT_DIR / "data/embeddings/image_embeddings.parquet")

# text = 773 columns 
text = pl.read_parquet(PROJECT_DIR / "data/embeddings/text_embeddings.parquet")

# tabular = 21 columns
tabular = pl.read_parquet(PROJECT_DIR / "data/embeddings/tabular_embeddings.parquet")

#------- Spectral Analysis (Principal Components)

image = image.select(cs.starts_with("image_")).to_numpy()
text = text.select(cs.starts_with("text_")).to_numpy()
tabular = tabular.select(cs.starts_with("tabular_")).to_numpy()

# save the singular values from SVD 

image_U, image_s, image_Vt = np.linalg.svd(image)

text_U, text_s, text_Vt = np.linalg.svd(text)

singular_values = pd.DataFrame({
    "image_s": image_s,
    "text_s": text_s
})

singular_values.to_csv(
    PROJECT_DIR / "data/spectral/singular_values.csv", 
    index = False
)

# plot the singular values and check whether they decay -- this is in the generate_figures.R script! 

#--------- Canonical Correlation Analysis 

# CCA is a model/estimator object from scikit-learn 
# .fit means learn from the data 
# .transform means apply the learned weights to data 

cca = CCA(n_components = 30, scale = True, max_iter = 10000)

image_c, text_c = cca.fit_transform(image, text)

canonical_corrs = [
    np.corrcoef(image_c[:, i], text_c[:, i])[0, 1]
    for i in range(10)
]













