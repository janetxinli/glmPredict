#' GLM Prediction
#'
#' Create a Generalised Linear Model (glm) from a dataset and a given set of variables, then
#' make predictions from the model, either on the original data or a new dataset.
#'
#' @param model_data dataframe or tibble
#' @param y target variable name/response (given as a character)
#' @param x features/terms (given as a single character or a character vector)
#' @param threshold probability threshold for predicting positive class, default=0.5
#' @param predict_data new data to make predictions on. by default, glm_predict predicts on the original data used to create the model
#' @param ... other parameters to be passed into glm function
#'
#' @return A named list containing:
#' @return $model: fitted model object
#' @return $augment: augment object containing the predictions and statistics
#' @return $accuracy
#' @return $precision
#' @return $recall
#' @export
#'
#' @examples glm_predict(my_data, "y", "x")
#' @examples glm_predict(my_data, "y", c("x", "z"), threshold=0.8, predict_data=new_data)
glm_predict <- function(model_data, y, x, threshold=0.5, predict_data=NA, ...) {
  # Check that input types are as expected
  if ((!"data.frame" %in% class(model_data)) & (!"tbl" %in% class(model_data))) {
    stop("Error: model_data must be a data frame or tibble")
  }
  if (typeof(x) != "character") {
   stop("Error: feature column name(s) must be given as a character or character vector")
  }
  if (typeof(y) != "character") {
    stop("Error: target column name must be given as a character")
  }
  if (typeof(threshold) != "double") {
    stop("Error: probability threshold must be a double")
  }
  if (!is.na(predict_data) & (!"data.frame" %in% class(predict_data)) & !("tbl" %in% class(predict_data))) {
    stop("Error: predict_data must be a data frame or tibble")
  }

  # Check if columns exist in model_data
  if (!y %in% colnames(model_data)) {
    stop("Error: target column name does not exist within model_data")
  }
  if (sum(x %in% colnames(model_data)) != length(x)) {
    stop("Error: one or more feature column names does not exist within model_data")
  }

  # Create the model and augment object
  if (is.vector(x)) {
    x <- paste(x, collapse=" + ")
  }
  f <- paste(y, "~", x)
  model <- stats::glm(stats::as.formula(f), family="binomial", data=model_data, ...)

  if (is.na(predict_data)) {
    a <- broom::augment(model, type.predict="response")
  }
  else {
    a <- broom::augment(model, type.predict="response", newdata=predict_data)
  }

  # Predict based on the given threshold
  a <- a %>%
    dplyr::mutate(.prediction=ifelse(.fitted > threshold, 1, 0))

  # Calculate error types and metrics
  true_pos <- sum(a[[".prediction"]]==1 & a[[y]]==1)
  false_pos <- sum(a[[".prediction"]]==1 & a[[y]]==0)
  false_neg <- sum(a[[".prediction"]]==0 & a[[y]]==1)

  accuracy <- mean(a[[".prediction"]]==a[[y]])
  precision <- true_pos / (true_pos + false_pos)
  recall <- true_pos / (true_pos + false_neg)

  # Return model, model info and metrics
  list("model"=model, "augment"=a, "accuracy"=accuracy, "precision"=precision, "recall"=recall)
}
