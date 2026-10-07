#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from pathlib import Path
import pandas as pd
import numpy as np 
import polars as pl
import polars.selectors as cs
import pyarrow as pa 


#path = Path(__file__).resolve().parent.parent

path = Path('/Users/juhuijin/Desktop/ccr/demand-analysis-repro/')

# there are 21,560 rows for each embedding file (1,540 products × 14 periods = 21,560 rows)

# image = 773 columns 
image = pl.read_parquet(path / "data/embeddings/image_embeddings.parquet")

# text = 773 columns 
text = pl.read_parquet(path / "data/embeddings/text_embeddings.parquet")

# tabular = 21 columns
tabular = pl.read_parquet(path / "data/embeddings/tabular_embeddings.parquet")

#------- Spectral Analysis

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
    path / "data/spectral/singular_values.csv", 
    index = False
)

# plot the singular values and check whether they decay 















