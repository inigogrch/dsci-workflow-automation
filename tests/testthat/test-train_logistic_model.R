# tests/testthat/test-train_logistic_model.R
library(testthat)
library(pROC)

# Source the function to test
source(here::here("R", "train_logistic_model.R"))

# Create a small test dataset
create_test_data <- function() {
  set.seed(123)  # For reproducibility
  n <- 100
  age <- rnorm(n, mean = 40, sd = 10)
  education_num <- sample(1:16, n, replace = TRUE)
  hours_per_week <- rnorm(n, mean = 40, sd = 10)
  
  # Create binary outcome with some relationship to predictors
  logit <- -5 + 0.05*age + 0.3*education_num + 0.02*hours_per_week + rnorm(n, 0, 1)
  prob <- 1/(1 + exp(-logit))
  income <- factor(ifelse(prob > 0.5, ">50K", "<=50K"), levels = c("<=50K", ">50K"))
  
  # Create and return the data frame
  data.frame(
    age = age,
    education_num = education_num,
    hours_per_week = hours_per_week,
    income = income
  )
}

test_that("train_logistic_model creates a valid model", {
  # Create test data
  test_data <- create_test_data()
  
  # Train model
  result <- train_logistic_model(
    data = test_data,
    outcome_var = "income",
    predictor_vars = c("age", "education_num", "hours_per_week")
  )
  
  # Test that the function returns expected objects
  expect_true("model" %in% names(result))
  expect_true("roc_curve" %in% names(result))
  expect_true("formula" %in% names(result))
  
  # Test that the model is a glm object
  expect_s3_class(result$model, "glm")
  
  # Test that the roc_curve is a valid roc object
  expect_s3_class(result$roc_curve, "roc")
  
  # Test that the AUC is between 0 and 1
  expect_true(pROC::auc(result$roc_curve) >= 0 && pROC::auc(result$roc_curve) <= 1)
})

test_that("train_logistic_model handles errors properly", {
  # Create test data
  test_data <- create_test_data()
  
  # Test with non-existent outcome variable
  expect_error(
    train_logistic_model(
      data = test_data,
      outcome_var = "nonexistent",
      predictor_vars = c("age", "education_num")
    ),
    "The outcome variable is not present in the data"
  )
  
  # Test with non-existent predictor variable
  expect_error(
    train_logistic_model(
      data = test_data,
      outcome_var = "income",
      predictor_vars = c("age", "nonexistent")
    ),
    "The following predictor variables are not present in the data: nonexistent"
  )
  
  # Test with non-data frame input
  expect_error(
    train_logistic_model(
      data = "not a data frame",
      outcome_var = "income",
      predictor_vars = c("age")
    ),
    "'data' must be a data frame"
  )
})

test_that("train_logistic_model formula construction is correct", {
  # Create test data
  test_data <- create_test_data()
  
  # Train model with different predictors
  result <- train_logistic_model(
    data = test_data,
    outcome_var = "income",
    predictor_vars = c("age", "hours_per_week")  # Excluding education_num
  )
  
  # Check that the formula includes only the specified predictors
  expected_formula <- as.formula("income ~ age + hours_per_week")
  expect_equal(deparse(result$formula), deparse(expected_formula))
})