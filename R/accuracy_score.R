#' Accuracy Score
#'
#' Given a set of predictions from `glm_predict` and the correct data,
#' returns the accuracy of the predictions.
#'
#' @param data True/correct labels.
#' @param predictions Predicted labels.
#' @param normalize Normalize the accuracy to the number of samples. default = `TRUE`.
#'
#' @return `accuracy` (numeric): If `normalize==TRUE`, this is the fraction of correctly classified examples. Otherwise, returns the number correct predictions.
#' @export
accuracy_score <- function(data, predictions, normalize=TRUE) {  # Change data arg to `correct`
  if (length(data) != length(predictions)) {
    stop("Error: data and predictions are not the same length")
  }
  accuracy <- mean(data == predictions)
  if (normalize) {
    return(accuracy)
  }
  else {
    return(accuracy * length(data))
  }
}
