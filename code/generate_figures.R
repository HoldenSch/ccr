
library(dplyr)
library(tidyr)

path = "/Users/juhuijin/Desktop/ccr/demand-analysis-repro/"

source(file.path(path, "utils/style.R"))

singular_vals = read.csv(file.path(path, "/data/spectral/singular_values.csv"))

singular_vals = singular_vals %>% mutate(dim = row_number())

#----- Log Scale 

image_log = ggplot(data = singular_vals %>% filter(dim <= 30)) + 
  geom_point(aes(x = dim, y = image_s), color = OI_COLORS[1]) + 
  geom_line(aes(x = dim, y = image_s), color = OI_COLORS[1]) + 
  scale_y_log10() +
  labs(
    x = "Dimension", 
    y = "Singular Value (log scale)", 
    title = "First 30 Singular Values (Image Embeddings)"
  ) + 
  theme_oi()

image_log

text_log = ggplot(data = singular_vals %>% filter(dim <= 30)) + 
  geom_point(aes(x = dim, y = text_s), color = OI_COLORS[2]) + 
  geom_line(aes(x = dim, y = text_s), color = OI_COLORS[2]) + 
  scale_y_log10() + 
  labs(
    x = "Dimension", 
    y = "Singular Value (log scale)", 
    title = "First 30 Singular Values (Text Embeddings)"
  ) + 
  theme_oi()

text_log 


#----- Regular y-Scale 

image = ggplot(data = singular_vals %>% filter(dim <= 30)) + 
  geom_point(aes(x = dim, y = image_s), color = OI_COLORS[1]) + 
  geom_line(aes(x = dim, y = image_s), color = OI_COLORS[1]) + 
  labs(
    x = "Dimension", 
    y = "Singular Value", 
    title = "First 30 Singular Values (Image Embeddings)"
  ) + 
  theme_oi()

image

text = ggplot(data = singular_vals %>% filter(dim <= 30)) + 
  geom_point(aes(x = dim, y = text_s), color = OI_COLORS[2]) + 
  geom_line(aes(x = dim, y = text_s), color = OI_COLORS[2]) + 
  labs(
    x = "Dimension", 
    y = "Singular Value", 
    title = "First 30 Singular Values (Text Embeddings)"
  ) + 
  theme_oi()

text

#----- Save plots 

ggsave(plot = image, filename = file.path(path, "figures/image_spectral_decomp.png"), width = 9, height = 6)
ggsave(plot = image_log, filename = file.path(path, "figures/image_spectral_decomp_log.png"), width = 9, height = 6)
ggsave(plot = text, filename = file.path(path, "figures/text_spectral_decomp.png"), width = 9, height = 6)
ggsave(plot = text_log, filename = file.path(path, "figures/text_spectral_decomp_log.png"), width = 9, height = 6)



