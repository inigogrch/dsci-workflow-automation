# test_download_data.R

# Source the function file from download_data.R 
source("R/download_data.R") 

library(testthat)
# testing with the UCI housing data set
test_that("download_data works correctly", {
  test_url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/housing/housing.data"
  test_output <- "housing.data"
  
  # Run the function and check if the file is downloaded
  download_data(test_url, test_output)
  
  # Check if the file now exists in the expected location
  expect_true(file.exists(test_output))
})