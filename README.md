# glmPredict

### Exercise 1.1: My Development

I started by using `devtools` to set up the structure of my package:
```r
library(devtools)
create_package("~/Documents/school/masters/stat545/glmPredict")
```

I set up Git manually through the command line. Then, I opened up the `glmPredict` directory in Rstudio and created an R file for my function with:
```r
use_r("predict")
```

I copied my function from Assignment 1b directly into the created file, `R/predict.R`. Since my function has a few dependencies, I used the `use_package` function to explicitly tell `devtools` that these are required:

```r
use_package("broom")
use_package("dplyr")
use_package("stats")
use_package("datateachr")
```

I also changed the function calls in `R/predict.R` to explicitly call the functions from their respective packages (i.e. changed `as.formula(f)` to `stats::as.formula(f)`.

Next, I added the documentation skeleton to my file with `Code > Insert Roxygen Skeleton`, and added some information about the function parameters, return value and a couple of example function calls. Then, I added licensing information and aggregated the documentation:

```r
use_mit_license("Janet Li")
document()
```

At this point, I wanted to check to make sure that I was on the right track, so I used `load_all()` to do a quick manual test of the function. Everything was working as expected, so I ran `check()`... and got an error! Turns out the `@examples` portion of the `roxygen2` skeleton actually runs the code, and I was using variable names that didn't exist in my environment.

To ensure that the examples (and my future tests) are able to run, I used `use_data_raw(name="cancer_clean")` to create an R script to clean a dataset to `data-raw/cancer_clean.R`. After adding my code to this file, I ran `usethis::use_data(cancer_clean, overwrite = TRUE)` to add the `.rda` object to the `data` directory, then I documented the dataset in `R/data.R`. I ran `check()` again and was still having some issues with the pipe operator (`%>%`) being recognized, despite stating `dplyr` as a dependency. After some digging, I realized I had to add this to my `roxygen2` comment:

```r
#' @examples require(dplyr)
```

**still getting a note: `glm_predict: no visible global function definition for '%>%'

To add some tests to my package, I used `use_test()` and moved over my tests from Assignment 1b to the `tests/testthat/test-predict.R`. After running the tests manually, I used `test()` to run the automated test. Everything passed!

To create a vignette, I used `use_vignette("glmPredict")`.
