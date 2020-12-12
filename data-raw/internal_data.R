## code to prepare `cancer_subset` dataset goes here
set.seed(123)
train_size <- floor(0.75 * nrow(cancer_clean))
train_ind <- sample(seq_len(nrow(cancer_clean)), size=train_size)

cancer_subset <- cancer_clean[train_ind,]
cancer_new <- cancer_clean[-train_ind,]

cancer_true_labels <- cancer_clean[["malignant"]]

cancer_model <- glm(malignant ~ radius_mean + concavity_mean, data=cancer_clean, family="quasibinomial")
cancer_predictions <- glm_predict(cancer_model, "malignant")[[".prediction"]]

# Save internal data
usethis::use_data(cancer_subset, cancer_new, cancer_true_labels, cancer_predictions,
  internal=TRUE, overwrite=TRUE)
