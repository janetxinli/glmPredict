#' Accuracy Score
#'
#' Given a set of predictions from `glm_predict` and the correct data,
#' returns the accuracy of the predictions.
#'
#' @param correct True/correct labels.
#' @param predictions Predicted labels.
#' @param normalize Normalize the accuracy to the number of samples. default = `TRUE`.
#'
#' @return `accuracy` (numeric): If `normalize==TRUE`, this is the fraction of correctly classified examples. Otherwise, returns the number correct predictions.
#' @export
#' @examples cancer_model <- glm(malignant ~ texture_mean, data=cancer_clean, family="quasibinomial")
#' @examples cancer_preds <- glm_predict(cancer_model, "malignant")
#' @examples accuracy <- accuracy_score(cancer_clean[["malignant"]], cancer_preds[[".prediction"]])
accuracy_score <- function(correct, predictions, normalize=TRUE) {  # Change data arg to `correct`
  if (length(correct) != length(predictions)) {
    stop("Error: data and predictions are not the same length")
  }
  accuracy <- mean(correct == predictions)
  if (normalize) {
    return(accuracy)
  }
  else {
    return(accuracy * length(correct))
  }
}
