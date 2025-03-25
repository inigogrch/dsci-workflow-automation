# R/compute_model_metrics.R

compute_model_metrics <- function(confusion_matrix) {
    tp <- confusion_matrix[">50K", ">50K"]
    tn <- confusion_matrix["<=50K", "<=50K"]
    fp <- confusion_matrix[">50K", "<=50K"]
    fn <- confusion_matrix["<=50K", ">50K"]
    n <- tp + tn + fp + fn

    sensitivity <- tp / (tp + fn)
    specificity <- tn / (tn + fp)
    precision <- tp / (tp + fp)
    accuracy <- (tp + tn) / n
    observed_accuracy <- (tp + tn) / n
    expected_accuracy <- ((tp + fp) / n) * ((tp + fn) / n) + ((tn + fp) / n) * ((tn + fn) / n)
    kappa <- (observed_accuracy - expected_accuracy) / (1 - expected_accuracy)

    data.frame(
        Metric = c("Sensitivity", "Specificity", "Precision", "Accuracy", "Cohen's Kappa"),
        Value = c(sensitivity, specificity, precision, accuracy, kappa)
    )
}
