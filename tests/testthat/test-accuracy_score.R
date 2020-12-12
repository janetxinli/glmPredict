context("Test accuracy_score")

correct <- sum(cancer_true_labels == cancer_predictions)
exp_accuracy <- correct / length(cancer_true_labels)

test_that("Gives the expected result", {
  expect_equal(accuracy_score(cancer_true_labels, cancer_predictions), exp_accuracy)
  expect_equal(accuracy_score(cancer_true_labels, cancer_predictions, normalize=FALSE), correct)
})

test_that("Throws an error if inputs aren't the same length", {
  # Correct + predicted labels have different lengths
  expect_error(accuracy_score(cancer_true_labels, cancer_predictions[1:20]))
  expect_error(accuracy_score(cancer_true_labels[1:50], cancer_predictions))
})

