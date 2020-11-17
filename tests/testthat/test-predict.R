cancer_model <- glm(malignant ~ radius_mean + concavity_mean, data=cancer_clean, family="binomial")

exp_predictions <- broom::augment(cancer_model, type.predict="response") %>%
  dplyr::summarize(prediction=ifelse(.fitted > 0.5, 1, 0))

exp_accuracy <- sum(exp_predictions==cancer_clean$malignant) / length(cancer_clean$malignant)
exp_precision <- (sum(cancer_clean$malignant==1 & exp_predictions==1)) / ((sum(cancer_clean$malignant==0 & exp_predictions==1)) +
  (sum(cancer_clean$malignant==1 & exp_predictions==1)))
exp_recall <- (sum(cancer_clean$malignant==1 & exp_predictions==1)) / ((sum(cancer_clean$malignant==1 & exp_predictions==0)) +
  (sum(cancer_clean$malignant==1 & exp_predictions==1)))

test_that("Outputs the correct values", {
  expect_equal(glm_predict(cancer_clean, "malignant", c("radius_mean", "concavity_mean"))$accuracy, exp_accuracy)  # Calculated accuracy
  expect_equal(glm_predict(cancer_clean, "malignant", c("radius_mean", "concavity_mean"))$precision, exp_precision)  # Calculated precision
  expect_equal(glm_predict(cancer_clean, "malignant", c("radius_mean", "concavity_mean"))$recall, exp_recall)  # Calculated recall
})

test_that("Throws errors if improper parameter values are given", {
  expect_error(glm_predict(1:20, "malignant", c("radius_mean", "concavity_mean")))  # Improper model_data data type
  expect_error(glm_predict(cancer_clean, "diagnosis", "radius_mean"))  # Target variable doesn't exist in model_data
  expect_error(glm_predict(cancer_clean, "malignant", c("radius_mean", "concavity_mean"), threshold="half"))  # Improper data type for threshold
})
