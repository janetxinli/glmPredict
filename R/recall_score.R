#' Recall Score
#'
#' @param correct True/correct labels.
#' @param predictions Predicted labels.
#' @param pos_class Positive class label. Like the y value in `glm`, this must be between 0 and 1. default=`1`.
#' @param neg_class Negative class label. Like the y value in `glm`, this must be between 0 and 1. default=`0`.
#'
#' @return `recall` (numeric): The recall (true positives / true positives + false negatives) of the predictions
#' @export
#'
#' @examples cancer_model <- glm(malignant ~ texture_mean, data=cancer_clean, family="quasibinomial")
#' @examples cancer_preds <- glm_predict(cancer_model, "malignant")
#' @examples recall <- recall_score(cancer_clean[["malignant"]], cancer_preds[[".prediction"]])
recall_score <- function(correct, predictions, pos_class=1, neg_class=0) {
  if (length(correct) != length(predictions)) {
    stop("Error: correct labels and predictions are not the same length")
  }
  if (length(unique(correct)) != 2) {
    stop("Error: 'correct label' dataset contains more than two labels")
  }
  if (length(unique(predictions)) != 2) {
    stop("Error: predictions contain more than two labels")
  }
  tp <- sum(correct == pos_class & predictions == pos_class)
  fn <- sum(correct == pos_class & predictions == neg_class)
  return(tp / (tp + fn))
}
