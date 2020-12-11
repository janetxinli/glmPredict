
# glmPredict

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) <!-- badges: end -->

glmPredict extends the functionality of the `augment.glm` function of the `broom` package to make class predictions for a dataset with a Generalised Linear Model. This package was created for an assignment in [STAT545B](https://stat545.stat.ubc.ca/).

## Installation

You can install the development version from [GitHub](https://github.com/janetxinli/glmPredict) with:

``` r
install.packages("devtools")
devtools::install_github("janetxinli/glmPredict")
```

## Examples

We're going to predict the malignancy of samples in a cleaned version of the [Breast Cancer Wisconsin Dataset](https://archive.ics.uci.edu/ml/datasets/Breast+Cancer+Wisconsin+(Diagnostic)) by creating a simple Generalised Linear Model. The dataset, `cancer_clean`, is available in the `glmPredict` package, where it has been slightly shrunk down from the original. The final diagnosis of the samples are encoded by the `malignant` column, where a value of 1 means the sample was diagnosed as malignant, and a sample of 0 means the sample was benign.

First, we need to make the `glm`, with `family=binomial` or `family=quasibinomial` to specify the response as a factor. The data will be subsetted as well, so we have a set of unseen data to pass into `glm_predict` later.

``` r
library(glmPredict)

# Start by subsetting the data
set.seed(123)
subset_len <- floor(0.75 * nrow(cancer_clean))
subset_ind <- sample(seq_len(nrow(cancer_clean)), size=subset_len)
cancer_subset <- cancer_clean[subset_ind,]
cancer_new <- cancer_clean[-subset_ind,]

# Create a glm with cancer_subset
(cancer_model <- glm(malignant ~ texture_mean + radius_mean, data=cancer_subset, family="binomial"))
#> 
#> Call:  glm(formula = malignant ~ texture_mean + radius_mean, family = "binomial", 
#>     data = cancer_subset)
#> 
#> Coefficients:
#>  (Intercept)  texture_mean   radius_mean  
#>     -19.0491        0.2094        1.0021  
#> 
#> Degrees of Freedom: 425 Total (i.e. Null);  423 Residual
#> Null Deviance:       551.5 
#> Residual Deviance: 219.8     AIC: 225.8
```

Then, we can use the `cancer_model` to make predictions, setting the threshold for predicting the positive class (malignant in this case) to 0.6 for example purposes:

``` r
(cancer_predictions <- glm_predict(cancer_model, "malignant"))
#> # A tibble: 426 x 11
#>    .rownames malignant texture_mean radius_mean .fitted  .resid .std.resid
#>    <chr>         <dbl>        <dbl>       <dbl>   <dbl>   <dbl>      <dbl>
#>  1 415               1         29.8       15.1  9.13e-1  0.425      0.429 
#>  2 463               0         27.0       14.4  7.38e-1 -1.64      -1.66  
#>  3 179               0         22.2       13.0  2.05e-1 -0.677     -0.680 
#>  4 526               0         13.1        8.57 4.45e-4 -0.0299    -0.0299
#>  5 195               1         23.2       14.9  6.69e-1  0.897      0.902 
#>  6 118               1         16.7       14.9  3.42e-1  1.47       1.47  
#>  7 299               0         18.2       14.3  2.78e-1 -0.808     -0.811 
#>  8 229               0         24.0       12.6  2.01e-1 -0.669     -0.674 
#>  9 244               0         23.8       13.8  4.28e-1 -1.06      -1.06  
#> 10 14                1         24.0       15.8  8.64e-1  0.540      0.543 
#> # … with 416 more rows, and 4 more variables: .hat <dbl>, .sigma <dbl>,
#> #   .cooksd <dbl>, .prediction <dbl>
```

The function returns the `augment` object which contains the predictions (`.prediction` column).

``` r
cancer_predictions[[".prediction"]]
#>   [1] 1 1 0 0 1 0 0 0 0 1 1 1 0 0 1 0 0 1 1 0 1 1 0 0 1 1 1 0 0 0 0 0 0 0 1 0 1
#>  [38] 0 0 0 0 0 1 1 0 0 1 1 0 1 0 1 0 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 1 0 0 1 0
#>  [75] 0 1 0 0 0 1 0 0 0 1 1 0 0 0 0 1 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 1 0 0 0
#> [112] 0 1 0 0 0 0 1 1 1 0 1 0 0 1 0 0 0 0 0 1 0 1 1 0 1 1 0 0 0 1 0 0 0 1 0 0 0
#> [149] 1 0 0 0 0 1 1 0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 1 0 1 0 0 0 0 1 1 0 0 1 0 0 1
#> [186] 0 0 0 1 1 0 0 0 0 0 0 0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 0 1 1 1 0 1
#> [223] 0 0 1 0 0 0 1 0 0 1 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 1
#> [260] 0 1 1 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1 0 1 0 0 0 0 1 0 1 0 1 1
#> [297] 0 0 1 0 0 1 0 0 1 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 1 0 0 1 1 1 1 0 0 0
#> [334] 1 0 0 0 1 1 0 0 0 1 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0
#> [371] 0 1 1 0 0 0 0 0 1 0 1 0 1 0 1 1 1 1 1 0 1 0 1 1 0 0 1 1 0 0 0 0 0 1 1 0 1
#> [408] 0 1 1 0 0 0 0 1 1 0 0 0 0 0 0 1 0 0 1
```

You can also pass a different dataset (one not used to create the `glm`) to make predictions with `glm_predict`. To do so, you just need to specify the dataset with the `newdata` argument.

``` r
glm_predict(cancer_model, "malignant", threshold=0.6, newdata=cancer_new)
#> # A tibble: 143 x 13
#>    malignant radius_mean texture_mean perimeter_mean area_mean smoothness_mean
#>        <dbl>       <dbl>        <dbl>          <dbl>     <dbl>           <dbl>
#>  1         1        18.0         10.4          123.      1001           0.118 
#>  2         1        20.6         17.8          133.      1326           0.0847
#>  3         1        13           21.8           87.5      520.          0.127 
#>  4         1        13.7         22.6           93.6      578.          0.113 
#>  5         1        14.7         20.1           94.7      684.          0.0987
#>  6         1        16.1         20.7          108.       799.          0.117 
#>  7         0        13.1         15.7           85.6      520           0.108 
#>  8         1        18.6         20.2          122.      1094           0.0944
#>  9         1        11.8         18.7           77.9      441.          0.111 
#> 10         1        16.1         17.9          107        807.          0.104 
#> # … with 133 more rows, and 7 more variables: compactness_mean <dbl>,
#> #   concavity_mean <dbl>, concave_points_mean <dbl>, symmetry_mean <dbl>,
#> #   fractal_dimension_mean <dbl>, .fitted <dbl>, .prediction <dbl>
```

There are several metrics for evaluating predictons in a binary classification problem, such as accuracy, precision and recall. `glmPredict` provides functions to calculate these three scores:

``` r
true_labels <- cancer_subset[["malignant"]]
predicted_labels <- cancer_predictions[[".prediction"]]
accuracy_score(true_labels, predicted_labels)
#> [1] 0.8896714
```

``` r
precision_score(true_labels, predicted_labels)
#> [1] 0.8863636
recall_score(true_labels, predicted_labels)
#> [1] 0.7852349
```

## Code of Conduct

Please note that the glmPredict project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.

------------------------------------------------------------------------

### Exercise 1.1: My Development

I started by using devtools to set up the structure of my package:

``` r
library(devtools)
create_package("~/Documents/school/masters/stat545/glmPredict")
```

I set up Git manually through the command line. Then, I opened up the glmPredict directory in Rstudio and created an R file for my function with `use_r("predict")`.

I copied my function from Assignment 1b directly into the created file, R/predict.R, and made some changes that I thought would make it more usable. Since my function has a few dependencies, I used the use\_package function to explicitly tell devtools that these are required:

``` r
use_package("broom")
use_package("dplyr")
use_package("stats")
use_package("datateachr")
use_pipe()
```

I also changed the function calls in `R/predict.R` to explicitly call the functions from their respective packages (i.e. changed `as.formula(f)` to `stats::as.formula(f)`).

Next, I added the documentation skeleton to my file with `Code > Insert Roxygen Skeleton`, and added some information about the function parameters, return value and a couple of example function calls. Then, I added licensing information and aggregated the documentation:

``` r
use_mit_license("Janet Li")
document()
```

At this point, I wanted to check to make sure that I was on the right track, so I used `load_all()` to do a quick manual test of the function. Everything was working as expected, so I ran `check()`... and got an error! Turns out the `@examples` portion of the roxygen2 skeleton actually runs the code, and I was using variable names that didn't exist in my environment.

To ensure that the examples (and my future tests) are able to run, I used `use_data_raw(name="cancer_clean")` to create an R script to clean a dataset to `data-raw/cancer_clean.R`. After adding my code to this file, I ran `usethis::use_data(cancer_clean, overwrite = TRUE)` to add the `.rda` object to the data directory, then I documented the dataset in `R/data.R`.

To add some tests to my package, I used `use_test()` and moved over my tests from Assignment 1b to the `tests/testthat/test-predict.R`. After running the tests manually, I used `test()` to run the automated test. Everything passed!

To create a vignette, I used `use_vignette("glmPredict")`, and added some more detailed documentation to `vignettes/vignette.Rmd`.

Finally, I added a code of conduct and created a package website with:

``` r
use_code_of_conduct()
use_pkgdown()
build_site()
```

To render this README file, I used `build_readme()`.
