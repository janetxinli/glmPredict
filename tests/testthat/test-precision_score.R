context("Test precision_score")

tp <- sum(cancer_predictions == 1 & cancer_true_labels == 1)
fp <- sum(cancer_predictions == 1 & cancer_true_labels == 0)

exp_precision <- tp / (tp + fp)

test_that("Gives the expected result", {
  expect_equal(precision_score(cancer_true_labels, cancer_predictions), exp_precision)
})

flipped_tf <- sum(cancer_predictions == 0 & cancer_true_labels == 0)
flipped_fp <- sum(cancer_predictions == 0 & cancer_true_labels == 1)
flipped_exp_precision <- flipped_tf / (flipped_tf + flipped_fp)

test_that("Works with different class labels", {
  expect_equal(precision_score(cancer_true_labels, cancer_predictions, pos_class=0, neg_class=1), flipped_exp_precision)
})

test_that("Throws an error for incorrect error format", {
  # Correct + predicted labels have different lengths
  expect_error(precision_score(cancer_true_labels, cancer_predictions[1:20]))
  expect_error(precision_score(cancer_true_labels[1:50], cancer_predictions))
  # More than 2 classes in either label
  cancer_true_adj <- cancer_true_labels
  cancer_true_adj[[1]] <- 2
  cancer_pred_adj <- cancer_predictions
  cancer_pred_adj[[1]] <- 2
  expect_error(precision_score(cancer_true_adj, cancer_predictions))
  expect_error(precision_score(cancer_true_labels, cancer_pred_adj))
})
