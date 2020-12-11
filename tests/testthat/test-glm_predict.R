context("Test glm_predict")

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

exp_predictions_subset_0.8 <- broom::augment(cancer_model, type.predict="response") %>%
  dplyr::summarize(prediction=ifelse(.fitted > 0.8, 1, 0))

exp_predictions_new_0.4 <- broom::augment(cancer_model, type.predict="response", newdata=cancer_new) %>%
  dplyr::summarize(prediction=ifelse(.fitted > 0.4, 1, 0))

# Tests
test_that("Outputs the correct values with default parameters", {
  function_output <- glm_predict(cancer_model, "malignant")
  expect_equal(dplyr::tibble(prediction=function_output[[".prediction"]]), exp_predictions_0.5)  # Predictions
})

test_that("Works with optional parameters on existing data in model", {
  subset_0.8_output <- glm_predict(cancer_model, "malignant", threshold=0.8)
  expect_equal(dplyr::tibble(prediction=subset_0.8_output[[".prediction"]]), exp_predictions_subset_0.8)  # Predictions
})

test_that("Works with optional parameters on new data", {
  new_0.4_output <- glm_predict(cancer_model, "malignant", threshold=0.4, newdata=cancer_new)
  expect_equal(dplyr::tibble(prediction=new_0.4_output[[".prediction"]]), exp_predictions_new_0.4)  # Predictions
})

test_that("Throws errors if improper parameter values are given", {
  expect_error(glm_predict(1:20, "malignant"))  # Improper model type
  expect_error(glm_predict(cancer_model, "diagnosis", threshold="half"))  # Improper data type for threshold
  expect_error(glm_predict(cancer_model, threshold=1))  # Improper value for threshold
})
