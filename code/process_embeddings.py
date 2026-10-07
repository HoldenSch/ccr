#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from pathlib import Path
import pandas as pd

path = Path(__file__).resolve().parent.parent

# there are 21,560 rows for each embedding file (1,540 products × 14 periods = 21,560 rows)

# image = 773 columns 
image = pd.read_parquet(path / "data/embeddings/image_embeddings.parquet")

# text = 773 columns 
text = pd.read_parquet(path / "data/embeddings/text_embeddings.parquet")

# tabular = 21 columns
tabular = pd.read_parquet(path / "data/embeddings/tabular_embeddings.parquet")

#------- Spectral Analysis
