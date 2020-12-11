#' Precision Score
#'
#' @param correct True/correct labels.
#' @param predictions Predicted labels.
#' @param pos_class The positive prediction class.
#'
#' @return `precision` (numeric): The precision (true positives / true positives + false positives) of the predictions
#' @export
precision_score <- function(correct, predictions, pos_class=1) {
  if (length(correct) != length(predictions)) {
    stop("Error: correct labels and predictions are not the same length")
  }
  classes <- unique(correct)
  if (length(classes) > 2 | length(unique(predictions)) > 2) {
    stop("Error: correct labels and predictions must contain 2 possible values")
  }
  neg_class <- classes[!classes == pos_class]
  tp <- sum(correct == pos_class & predictions == pos_class)
  fp <- sum(correct == neg_class & predictions == pos_class)
  return(tp / (tp + fp))
}
