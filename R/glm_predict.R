#' GLM Predict
#'
#' Create a Generalised Linear Model (glm) from a dataset and a given set of variables, then
#' make predictions from the model, either on the original data or a new dataset.
#'
#' @param model Fitted `glm` model object
#' @param target Target name (must be present as a column in the model object). This is the y variable when creating a `glm`.
#' @param pos_class Positive class label. default=`1`. Like the y value in `glm`, this must be between 0 and 1.
#' @param neg_class Negative class label. default=`0`. Like the y value in `glm`, this must be between 0 and 1.
#' @param threshold Probability threshold for predicting positive class. Must be between 0 and 1 (exclusive). default=`0.5`.
#' @param newdata New data to make predictions on. By default, `glm_predict` predicts on the original data used to create the model. default=`NULL`.
#' @param ... Other parameters to be passed into the `augment` function for making predictions.
#'
#' @return Augment object with a column `.prediction` that contains the predicted class for each example.
#' @export
#'
#' @examples require(dplyr)
#' @examples cancer_model <- glm(malignant ~ texture_mean, data=cancer_clean, family="quasibinomial")
#' @examples glm_predict(cancer_model, "malignant")
#' @examples glm_predict(cancer_model, "malignant", threshold=0.8)
glm_predict <- function(model, target, pos_class=1, neg_class=0, threshold=0.5, newdata=NULL, ...) {
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
    stop("Error: probability threshold value must be between 0 and 1")
  }

  if (!is.null(newdata) & (!"data.frame" %in% class(newdata)) & !("tbl" %in% class(newdata))) {
    stop("Error: newdata must be a data frame or tibble")
  }

  if (pos_class == neg_class) {
    stop("Error: positive and negative class labels cannot be identical")
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
    dplyr::mutate(.prediction=ifelse(a[[".fitted"]] > threshold, pos_class, neg_class))

  # Return augment object and predictions
  return(a)
}
