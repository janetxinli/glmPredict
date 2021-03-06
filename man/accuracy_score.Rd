% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/accuracy_score.R
\name{accuracy_score}
\alias{accuracy_score}
\title{Accuracy Score}
\usage{
accuracy_score(correct, predictions, normalize = TRUE)
}
\arguments{
\item{correct}{True/correct labels.}

\item{predictions}{Predicted labels.}

\item{normalize}{Normalize the accuracy to the number of samples. default = \code{TRUE}.}
}
\value{
\code{accuracy} (numeric): If \code{normalize==TRUE}, this is the fraction of correctly classified examples. Otherwise, returns the number correct predictions.
}
\description{
Given a set of predictions from \code{glm_predict} and the correct data,
returns the accuracy of the predictions.
}
\examples{
cancer_model <- glm(malignant ~ texture_mean, data=cancer_clean, family="quasibinomial")
cancer_preds <- glm_predict(cancer_model, "malignant")
accuracy <- accuracy_score(cancer_clean[["malignant"]], cancer_preds[[".prediction"]])
}
