#' Cleaned Diagnostic Breast Cancer Data
#'
#' A subset of a dataset containing quantitative features from images of nuclei from biopsies of breast masses from patients at the University
#' of Wisconsin Hospital. Malignancy is encoded as a binary variable (1 = malignant, 0 = benign).
#'
#' @format A tibble with 569 rows and 11 variables:
#' \describe{
#'   \item{malignant}{Whether the observation was diagnosed as malignant or benign}
#'   \item{radius_mean}{Mean radius of nuclei present in sample image}
#'   \item{texture_mean}{Mean texture of nuclei present in sample image}
#'   \item{perimeter_mean}{Mean perimeter of nuclei present in sample image}
#'   \item{area_mean}{Mean area of nuclei present in sample image}
#'   \item{smoothness_mean}{Mean smoothness of nuclei present in sample image}
#'   \item{compactness_mean}{Mean compactness of nuclei present in sample image}
#'   \item{concavity_mean}{Mean concavity of nuclei present in sample image}
#'   \item{concave_points_mean}{Mean concave points of nuclei present in sample image}
#'   \item{symmetry_mean}{Mean symmetry of nuclei present in sample image}
#'   \item{fractal_dimension_mean}{Mean factal dimension of nuclei present in sample image}
#'   }
#' @source \url{https://archive.ics.uci.edu/ml/citation_policy.html}
"cancer_clean"
