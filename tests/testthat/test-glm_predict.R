context("Test function")

# Prepare data
set.seed(123)
train_size <- floor(0.75 * nrow(cancer_clean))
train_ind <- sample(seq_len(nrow(cancer_clean)), size=train_size)

cancer_subset <- cancer_clean[train_ind,]
cancer_new <- cancer_clean[-train_ind,]

cancer_model <- glm(malignant ~ radius_mean + concavity_mean, data=cancer_subset, family="quasibinomial")

# Expected outputs
exp_predictions_0.5 <- broom::augment(cancer_model, type.predict="response") %>%
  dplyr::summarize(prediction=ifelse(.fitted > 0.5, 1, 0))

exp_accuracy_subset_0.5 <- sum(exp_predictions_0.5==cancer_subset$malignant) / length(cancer_subset$malignant)
exp_precision_subset_0.5 <- (sum(cancer_subset$malignant==1 & exp_predictions_0.5==1)) / ((sum(cancer_subset$malignant==0 & exp_predictions_0.5==1)) +
  (sum(cancer_subset$malignant==1 & exp_predictions_0.5==1)))
exp_recall_subset_0.5 <- (sum(cancer_subset$malignant==1 & exp_predictions_0.5==1)) / ((sum(cancer_subset$malignant==1 & exp_predictions_0.5==0)) +
  (sum(cancer_subset$malignant==1 & exp_predictions_0.5==1)))

exp_predictions_subset_0.8 <- broom::augment(cancer_model, type.predict="response") %>%
  dplyr::summarize(prediction=ifelse(.fitted > 0.8, 1, 0))

exp_accuracy_subset_0.8 <- sum(exp_predictions_subset_0.8==cancer_subset$malignant) / length(cancer_subset$malignant)

exp_predictions_new_0.4 <- broom::augment(cancer_model, type.predict="response", newdata=cancer_new) %>%
  dplyr::summarize(prediction=ifelse(.fitted > 0.4, 1, 0))

exp_precision_new_0.4 <- (sum(cancer_new$malignant==1 & exp_predictions_new_0.4==1)) / ((sum(cancer_new$malignant==0 & exp_predictions_new_0.4==1)) +
  (sum(cancer_new$malignant==1 & exp_predictions_new_0.4==1)))

# Tests
test_that("Outputs the correct values with default parameters", {
  function_output <- glm_predict(cancer_model, "malignant")
  expect_equal(function_output$accuracy, exp_accuracy_subset_0.5)  # Calculated accuracy
  expect_equal(function_output$precision, exp_precision_subset_0.5)  # Calculated precision
  expect_equal(function_output$recall, exp_recall_subset_0.5)  # Calculated recall
  expect_equal(dplyr::tibble(prediction=function_output$augment$.prediction), exp_predictions_0.5)  # Predictions
})

test_that("Works with optional parameters on existing data in model", {
  subset_0.8_output <- glm_predict(cancer_model, "malignant", threshold=0.8)
  expect_equal(subset_0.8_output$accuracy, exp_accuracy_subset_0.8)  # Calculated accuracy
  expect_equal(dplyr::tibble(prediction=subset_0.8_output$augment$.prediction), exp_predictions_subset_0.8)  # Predictions
})

test_that("Works with optional parameters on new data", {
  new_0.4_output <- glm_predict(cancer_model, "malignant", threshold=0.4, newdata=cancer_new)
  expect_equal(new_0.4_output$precision, exp_precision_new_0.4)  # Precision
  expect_equal(dplyr::tibble(prediction=new_0.4_output$augment$.prediction), exp_predictions_new_0.4)  # Predictions
})

test_that("Throws errors if improper parameter values are given", {
  expect_error(glm_predict(1:20, "malignant"))  # Improper model type
  expect_error(glm_predict(cancer_model, "diagnosis", threshold="half"))  # Improper data type for threshold
  expect_error(glm_predict(cancer_model, threshold=1))  # Improper value for threshold
})
