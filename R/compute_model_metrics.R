# R/compute_model_metrics.R

#' Compute evaluation metrics from a confusion matrix
#'
#' @param confusion_matrix A 2x2 matrix with named rows and columns
#' @return A data frame with model evaluation metrics
#' @export
compute_model_metrics <- function(confusion_matrix) {
    expected_labels <- c("<=50K", ">50K")
    if (!all(expected_labels %in% rownames(confusion_matrix)) ||
        !all(expected_labels %in% colnames(confusion_matrix))) {
        stop("Confusion matrix must have '<=50K' and '>50K' as row and column names.")
    }

    tp <- confusion_matrix[">50K", ">50K"]
    tn <- confusion_matrix["<=50K", "<=50K"]
    fp <- confusion_matrix[">50K", "<=50K"]
    fn <- confusion_matrix["<=50K", ">50K"]
    n <- tp + tn + fp + fn

    sensitivity <- tp / (tp + fn)
    specificity <- tn / (tn + fp)
    precision <- tp / (tp + fp)
    accuracy <- (tp + tn) / n

    observed_accuracy <- accuracy
    expected_accuracy <- ((tp + fp) / n) * ((tp + fn) / n) +
        ((tn + fp) / n) * ((tn + fn) / n)
    kappa <- (observed_accuracy - expected_accuracy) / (1 - expected_accuracy)

    metrics_df <- data.frame(
        Metric = c("Sensitivity", "Specificity", "Precision", "Accuracy", "Cohen's Kappa"),
        Value = c(sensitivity, specificity, precision, accuracy, kappa)
    )

    return(metrics_df)
}
