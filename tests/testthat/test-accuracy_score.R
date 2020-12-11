context("Test accuracy_score")

# Prepare data
set.seed(123)
train_size <- floor(0.75 * nrow(cancer_clean))
train_ind <- sample(seq_len(nrow(cancer_clean)), size=train_size)

cancer_subset <- cancer_clean[train_ind,]
cancer_new <- cancer_clean[-train_ind,]

cancer_model <- glm(malignant ~ radius_mean + concavity_mean, data=cancer_subset, family="quasibinomial")
cancer_preds <- glm_predict(cancer_model, "malignant")[[".prediction"]]
real <- cancer_subset[["malignant"]]

# Change this calculation
correct <- 0
num_values <- 0
for (i in seq_along(real)) {
  num_values <- num_values + 1
  if (cancer_preds[[i]] == real[[i]]) {
    correct <- correct + 1
  }
}
exp_accuracy <- correct / num_values

test_that("gives the expected result", {
  expect_equal(accuracy_score(real, cancer_preds), exp_accuracy)
  expect_equal(accuracy_score(real, cancer_preds, normalize=FALSE), correct)
})

test_that("throws an error if inputs aren't the same length", {
  expect_error(accuracy_score(real, cancer_preds[1:20]))
})
