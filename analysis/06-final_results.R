"
Script to display the final results of our model
Usage:
  analysis/06-final_results.R
  --input_data=<input>
  --input_model=<input>
  --output_plot=<output>
  --output_table=<output>

Options:
  --input_data=<input>   Path to cleaned testing dataset.
  --input_model=<input>   Path to model RDS object.
  --output_plot=<output> Path to save confusion matrix.
  --output_table=<output> Path to save model final results.
"
library(docopt)
library(readr)
library(ggplot2)

source("R/compute_model_metrics.R")

doc <- docopt("
Usage:
  analysis/06-final_results.R --input_data=<input> --input_model=<input> --output_plot=<output> --output_table=<output>
")
test_data <- read_csv(doc$input_data)
full_model <- readRDS(doc$input_model)

# Conf Matrix abstraction
test_pred_probs <- predict(full_model,
  newdata = test_data[, c("age", "hours_per_week", "education_num")], # nolint
  type = "response"
)
test_pred_class <- ifelse(test_pred_probs > 0.5, ">50K", "<=50K")
confusion_matrix <- table(
  Predicted = test_pred_class,
  Actual = test_data$income
)
conf_mat_df <- as.data.frame(confusion_matrix)
colnames(conf_mat_df) <- c("Actual", "Predicted", "Freq")
conf_matrix_plot <- ggplot(
  conf_mat_df,
  aes(x = Predicted, y = Actual, fill = Freq)
) +
  geom_tile() +
  geom_text(aes(label = Freq), color = "white", size = 6) +
  scale_fill_gradient(low = "lightblue", high = "darkblue") +
  theme_minimal(base_size = 14) +
  labs(
    title = "Confusion Matrix",
    x = "Predicted Class",
    y = "Actual Class"
  )
ggsave(doc$output_plot, plot = conf_matrix_plot)

# # Metrics Table abstraction
# tp <- confusion_matrix[">50K", ">50K"] # True Positives
# tn <- confusion_matrix["<=50K", "<=50K"] # True Negatives
# fp <- confusion_matrix[">50K", "<=50K"] # False Positives
# fn <- confusion_matrix["<=50K", ">50K"] # False Negatives
# n <- tp + tn + fp + fn # Total observations
# # Sensitivity (SN)
# sensitivity <- tp / (tp + fn)
# # Specificity (SP)
# specificity <- tn / (tn + fp)
# # Precision (PR)
# precision <- tp / (tp + fp)
# # Accuracy (ACC)
# accuracy <- (tp + tn) / n
# # Cohen's Kappa (κ)
# observed_accuracy <- (tp + tn) / n
# expected_accuracy <- ((tp + fp) / n) * ((tp + fn) / n) + ((tn + fp) / n) * ((tn + fn) / n) # nolint
# kappa <- (observed_accuracy - expected_accuracy) / (1 - expected_accuracy)
# metrics_df <- data.frame(
#   Metric = c("Sensitivity", "Specificity", "Precision", "Accuracy", "Cohen's Kappa"), # nolint
#   Value  = c(sensitivity, specificity, precision, accuracy, kappa)
# )
# write_csv(metrics_df, doc$output_table)

metrics_df <- calculate_model_metrics(confusion_matrix)
write_csv(metrics_df, doc$output_table)

message("Confusion matrix and final results table created successfully.")
