context("Test recall_score")

tp <- sum(cancer_predictions == 1 & cancer_true_labels == 1)
fn <- sum(cancer_predictions == 0 & cancer_true_labels == 1)
exp_recall <- tp / (tp + fn)

test_that("Gives the expected result", {
  expect_equal(recall_score(cancer_true_labels, cancer_predictions), exp_recall)
})

flipped_tf <- sum(cancer_predictions == 0 & cancer_true_labels == 0)
flipped_fn <- sum(cancer_predictions == 1 & cancer_true_labels == 0)
flipped_exp_recall <- flipped_tf / (flipped_tf + flipped_fn)

test_that("Works with different class labels", {
  expect_equal(recall_score(cancer_true_labels, cancer_predictions, pos_class=0, neg_class=1), flipped_exp_recall)
})

test_that("Throws an error for incorrect error format", {
  # Correct + predicted labels have different lengths
  expect_error(recall_score(cancer_true_labels, cancer_predictions[1:20]))
  expect_error(recall_score(cancer_true_labels[1:50], cancer_predictions))
  # More than 2 classes in either label
  cancer_true_adj <- cancer_true_labels
  cancer_true_adj[[1]] <- 2
  cancer_pred_adj <- cancer_predictions
  cancer_pred_adj[[1]] <- 2
  expect_error(recall_score(cancer_true_adj, cancer_predictions))
  expect_error(recall_score(cancer_true_labels, cancer_pred_adj))
})
