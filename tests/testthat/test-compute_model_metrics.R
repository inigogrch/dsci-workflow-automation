# source("R/compute_model_metrics.R")
# source("../../R/compute_model_metrics.R")
library(here)
library(testthat)

source(here::here("R", "compute_model_metrics.R"))

test_that("compute_model_metrics returns correct output for known confusion matrix", {
    cm <- matrix(c(50, 10, 5, 35), nrow = 2, byrow = TRUE)
    rownames(cm) <- c(">50K", "<=50K")
    colnames(cm) <- c(">50K", "<=50K")

    metrics <- compute_model_metrics(cm)

    expect_true("Accuracy" %in% metrics$Metric)
    expect_equal(nrow(metrics), 5)
    expect_type(metrics$Value, "double")

    actual_accuracy <- metrics$Value[metrics$Metric == "Accuracy"]
    expected_accuracy <- (50 + 35) / sum(cm)
    expect_equal(actual_accuracy, expected_accuracy)
})
