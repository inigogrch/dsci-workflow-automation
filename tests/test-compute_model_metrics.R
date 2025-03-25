library(testthat)
source("R/compute_model_metrics.R")

test_that("Compute_model_metrics returns correct output for known confusion matrix", {
    conf_matrix <- matrix(c(50, 10, 5, 35), nrow = 2, byrow = TRUE)
    rownames(conf_matrix) <- c(">50K", "<=50K")
    colnames(conf_matrix) <- c(">50K", "<=50K")

    metrics <- compute_model_metrics(conf_matrix)

    expect_true("Accuracy" %in% metrics$Metric)
    expect_equal(nrow(metrics), 5)
    expect_type(metrics$Value, "double")

    tp <- 50
    tn <- 35
    fp <- 5
    fn <- 10
    n <- 100
    expected_accuracy <- (tp + tn) / n
    actual_accuracy <- metrics$Value[metrics$Metric == "Accuracy"]
    expect_equal(actual_accuracy, expected_accuracy, tolerance = 1e-6)
})
