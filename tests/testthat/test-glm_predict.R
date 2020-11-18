context("Test function")

set.seed(123)
train_size <- floor(0.75 * nrow(cancer_clean))
train_ind <- sample(seq_len(nrow(cancer_clean)), size=train_size)

cancer_train <- cancer_clean[train_ind,]
cancer_test <- cancer_clean[-train_ind,]

cancer_model <- glm(malignant ~ radius_mean + concavity_mean, data=cancer_train, family="quasibinomial")

exp_predictions_0.5 <- broom::augment(cancer_model, type.predict="response") %>%
  dplyr::summarize(prediction=ifelse(.fitted > 0.5, 1, 0))

exp_accuracy_0.5 <- sum(exp_predictions_0.5==cancer_train$malignant) / length(cancer_train$malignant)
exp_precision_0.5 <- (sum(cancer_train$malignant==1 & exp_predictions_0.5==1)) / ((sum(cancer_train$malignant==0 & exp_predictions_0.5==1)) +
  (sum(cancer_train$malignant==1 & exp_predictions_0.5==1)))
exp_recall_0.5 <- (sum(cancer_train$malignant==1 & exp_predictions_0.5==1)) / ((sum(cancer_train$malignant==1 & exp_predictions_0.5==0)) +
  (sum(cancer_train$malignant==1 & exp_predictions_0.5==1)))

exp_predictions_0.8_train <- broom::augment(cancer_model, type.predict="response") %>%
  dplyr::summarize(prediction=ifelse(.fitted > 0.8, 1, 0))

exp_accuracy_0.8_train <- sum(exp_predictions_0.8_train==cancer_train$malignant) / length(cancer_train$malignant)

exp_predictions_0.4_test <- broom::augment(cancer_model, type.predict="response", newdata=cancer_test) %>%
  dplyr::summarize(prediction=ifelse(.fitted > 0.4, 1, 0))

exp_precision_0.4_test <- (sum(cancer_test$malignant==1 & exp_predictions_0.4_test==1)) / ((sum(cancer_test$malignant==0 & exp_predictions_0.4_test==1)) +
  (sum(cancer_test$malignant==1 & exp_predictions_0.4_test==1)))

test_that("Outputs the correct values with default parameters", {
  function_output <- glm_predict(cancer_model, "malignant")
  expect_equal(function_output$accuracy, exp_accuracy_0.5)  # Calculated accuracy
  expect_equal(function_output$precision, exp_precision_0.5)  # Calculated precision
  expect_equal(function_output$recall, exp_recall_0.5)  # Calculated recall
  expect_equal(dplyr::tibble(prediction=function_output$augment$.prediction), exp_predictions_0.5)  # Predictions
})

test_that("Works with optional parameters on existing data in model", {
  train_0.8_output <- glm_predict(cancer_model, "malignant", threshold=0.8)
  expect_equal(train_0.8_output$accuracy, exp_accuracy_0.8_train)  # Calculated accuracy
  expect_equal(dplyr::tibble(prediction=train_0.8_output$augment$.prediction), exp_predictions_0.8_train)  # Predictions
})

test_that("Works with optional parameters on new data", {
  test_0.4_output <- glm_predict(cancer_model, "malignant", threshold=0.4, newdata=cancer_test)
  expect_equal(test_0.4_output$precision, exp_precision_0.4_test)  # Precision
  expect_equal(dplyr::tibble(prediction=test_0.4_output$augment$.prediction), exp_predictions_0.4_test)  # Predictions
})

test_that("Throws errors if improper parameter values are given", {
  expect_error(glm_predict(1:20, "malignant"))  # Improper model type
  expect_error(glm_predict(cancer_model, "diagnosis", threshold="half"))  # Improper data type for threshold
  expect_error(glm_predict(cancer_model, threshold=1))  # Improper value for threshold
})
