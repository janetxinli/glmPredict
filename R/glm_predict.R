#' GLM Prediction
#'
#' Create a Generalised Linear Model (glm) from a dataset and a given set of variables, then
#' make predictions from the model, either on the original data or a new dataset.
#'
#' @param model Fitted `glm` model object
#' @param target Target name (must be present as a column in the model object). This is the y variable when creating a `glm`.
#' @param threshold Probability threshold for predicting positive class. Must be between 0 and 1 (exclusive). default=`0.5`.
#' @param newdata New data to make predictions on. By default, `glm_predict` predicts on the original data used to create the model. default=`NULL`.
#' @param ... Other parameters to be passed into the `augment` function for making predictions.
#'
#' @return A named list containing:
#' @return `$augment`: Augment object containing the model predictions and information about each observation.
#' @return `$accuracy`: Accuracy of predictions.
#' @return `$precision`: Precision of predictions.
#' @return `$recall`: Recall of predictions.
#' @export
#'
#' @examples require(dplyr)
#' @examples cancer_model <- glm(malignant ~ texture_mean, data=cancer_clean, family="quasibinomial")
#' @examples glm_predict(cancer_model, "malignant")
#' @examples glm_predict(cancer_model, "malignant", threshold=0.8)
glm_predict <- function(model, target, threshold=0.5, newdata=NULL, ...) {
  # Check that input types are as expected
  if (!"glm" %in% class(model)) {
    stop("Error: must provide a fitted Generalised Linear Model")
  }

  if (!target %in% colnames(model$data)) {
    stop("Error: target name provided is not present in model data")
  }

  if (typeof(threshold) != "double") {
    stop("Error: probability threshold must be a double")
  } else if (threshold >= 1 | threshold <= 0) {
    stop("Error: probability threshold valuemust be between 0 and 1")
  }

  if (!is.null(newdata) & (!"data.frame" %in% class(newdata)) & !("tbl" %in% class(newdata))) {
    stop("Error: newdata must be a data frame or tibble")
  }

  # Augment existing or new data
  if (is.null(newdata)) {
    a <- broom::augment(model, type.predict="response", ...)
  }
  else {
    a <- broom::augment(model, type.predict="response", newdata=newdata, ...)
  }

  # Predict based on the given threshold
  a <- a %>%
    dplyr::mutate(.prediction=ifelse(a[[".fitted"]] > threshold, 1, 0))

  # Calculate error types and metrics
  true_pos <- sum(a[[".prediction"]]==1 & a[[target]]==1)
  false_pos <- sum(a[[".prediction"]]==1 & a[[target]]==0)
  false_neg <- sum(a[[".prediction"]]==0 & a[[target]]==1)

  accuracy <- mean(a[".prediction"]==a[[target]])
  precision <- true_pos / (true_pos + false_pos)
  recall <- true_pos / (true_pos + false_neg)

  # Return model, model info and metrics
  list("augment"=a, "accuracy"=accuracy, "precision"=precision, "recall"=recall)
}
