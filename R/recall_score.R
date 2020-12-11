#' Recall Score
#'
#' @param correct True/correct labels.
#' @param predictions Predicted labels.
#' @param pos_class The positive prediction class.
#'
#' @return `recall` (numeric): The recall (true positives / true positives + false negatives) of the predictions
#' @export
recall_score <- function(correct, predictions, pos_class=1) {
  if (length(correct) != length(predictions)) {
    stop("Error: correct labels and predictions are not the same length")
  }
  classes <- unique(correct)
  if (length(classes) > 2 | length(unique(predictions)) > 2) {
    stop("Error: correct labels and predictions must contain 2 possible values")
  }
  neg_class <- classes[!classes == pos_class]
  tp <- sum(correct == pos_class & predictions == pos_class)
  fn <- sum(correct == pos_class & predictions == neg_class)
  return(tp / (tp + fn))
}
