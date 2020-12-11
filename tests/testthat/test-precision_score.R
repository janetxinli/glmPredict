context("Test precision_score")

# Prepare data
set.seed(123)
train_size <- floor(0.75 * nrow(cancer_clean))
train_ind <- sample(seq_len(nrow(cancer_clean)), size=train_size)

cancer_subset <- cancer_clean[train_ind,]
cancer_new <- cancer_clean[-train_ind,]

cancer_model <- glm(malignant ~ radius_mean + concavity_mean, data=cancer_subset, family="quasibinomial")
cancer_preds <- glm_predict(cancer_model, "malignant")[[".prediction"]]
real <- cancer_subset[["malignant"]]

tp <- sum(cancer_preds == 1 & real == 1)
fp <- sum(cancer_preds == 1 & real == 0)
exp_precision <- tp / (tp + fp)

test_that("gives the expected result", {
  expect_equal(precision_score(real, cancer_preds), exp_precision)
})

test_that("throws an error for incorrect error format", {
  expect_error(precision_score(real, cancer_preds[1:20]))
  cancer_preds[[1]] = 2  # Add a third class
  expect_error(precision_score(real, cancer_preds))
  cancer_preds[[1]] = 0  # Change back
})
