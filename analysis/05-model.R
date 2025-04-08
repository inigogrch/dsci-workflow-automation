"
Script to train a logistic regression model and display its outputs.
Usage:
  analysis/05-model.R --input=<input> --output_model=<output> --output_plot=<output>

Options:
  --input=<input>   Path to cleaned training dataset.
  --output_model=<output> Path to save model results.
  --output_plot=<output> Path to save model AUC visualization.
"

library(docopt)
library(readr)
library(ggplot2)
library(pROC)
library(incomepredictability)

# Source the logistic model function
# source("R/train_logistic_model.R")

doc <- docopt("
Usage:
  analysis/05-model.R --input=<input> --output_model=<output> --output_plot=<output>
")
train_data <- read_csv(doc$input)

# Define variables for the model
selected_vars <- c(
  "age",
  "education_num",
  "hours_per_week"
)

# Train the logistic regression model using our function
model_results <- train_logistic_model(
  data = train_data,
  outcome_var = "income",
  predictor_vars = selected_vars
)

# Save the model to RDS
saveRDS(model_results$model, doc$output_model)

# Create and save ROC plot
roc_plot <- ggroc(model_results$roc_curve, legacy.axes = TRUE) +
  xlim(0, 1) +
  ylim(0, 1) +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "gray") +
  coord_equal() +
  ggtitle("ROC Curve of Full Model")
ggsave(doc$output_plot, plot = roc_plot)

message("Model trained and AUC visualization created successfully.")
