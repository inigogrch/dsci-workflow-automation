"
Script to train a logistic regression model and display its outputs.
Usage:
  analysis/05-model.R --input=<input> 
  --output_model=<output> --output_plot=<output>

Options:
  --input=<input>   Path to cleaned training dataset.
  --output_model=<output> Path to save model results.
  --output_plot=<output> Path to save model AUC visualization.
"

library(docopt)
library(readr)
library(ggplot2)
library(pROC)

doc <- docopt("
Usage:
  05-model.R --input=<input> --output_model=<output> --output_plot=<output>
")
train_data <- read_csv(doc$input)

# Model abstraction
selected_vars <- c(
  "age",
  "education_num",
  "hours_per_week"
)
formula_reduced <- as.formula(paste("income ~",
                                    paste(selected_vars, collapse = " + ")))
full_model <- glm(formula_reduced, data = train_data, family = binomial)
saveRDS(full_model, doc$output_model)

# ROC abstraction
actual_classes <- train_data$income
predicted_probs <- predict(full_model, type = "response")
roc_curve <- roc(actual_classes, predicted_probs)
roc_plot <- ggroc(roc_curve, legacy.axes = TRUE) + 
  xlim(0, 1) +
  ylim(0, 1) +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "gray") +
  coord_equal() +
  ggtitle("ROC Curve of Full Model")
ggsave(doc$output_plot, plot = roc_plot)

message("Model trained and AUC visualization created successfully.")
