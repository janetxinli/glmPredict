## code to prepare `cancer_sample_clean` dataset goes here

library("datateachr")
cancer_clean = cancer_sample %>%
  mutate(malignant=ifelse(diagnosis=="M", 1, 0)) %>%
  select(malignant, ends_with("_mean"))

usethis::use_data(cancer_clean, overwrite = TRUE)
