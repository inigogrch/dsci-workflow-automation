# test_download_data.R
# source("R/download_data.R")
library(testthat)
library(here)
# source("../../R/download_data.R")
source(here::here("R", "download_data.R"))


test_that("download_data works correctly", {
  test_url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/housing/housing.data"
  test_output <- "housing.data"

  download_data(test_url, test_output)
  expect_true(file.exists(test_output))

  if (file.exists(test_output)) file.remove(test_output)
})
