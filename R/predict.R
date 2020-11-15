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
  model <- glm(as.formula(f), family="binomial", data=model_data, ...)

  if (is.na(predict_data)) {
    a <- augment(model, type.predict="response")
  }
  else {
    a <- augment(model, type.predict="response", newdata=predict_data)
  }

  # Predict based on the given threshold
  a <- a %>%
    mutate(.prediction=ifelse(.fitted > threshold, 1, 0))

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
