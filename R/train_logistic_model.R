# R/train_logistic_model.R

#' Train a logistic regression model for binary classification
#'
#' This function trains a logistic regression model on the provided dataset
#' using the specified predictor variables and binary outcome variable.
#'
#' @param data A data frame containing the variables to be used in the model
#' @param outcome_var A string specifying the name of the binary outcome variable
#' @param predictor_vars A character vector specifying the names of predictor variables
#' @param pos_class A string specifying the positive class in the outcome variable
#' @param neg_class A string specifying the negative class in the outcome variable
#'
#' @return A list containing the trained model and the ROC curve object
#' @export
#'

train_logistic_model <- function(data, outcome_var, predictor_vars, 
                                pos_class = ">50K", neg_class = "<=50K") {
  # Check if required packages are available
  if (!requireNamespace("pROC", quietly = TRUE)) {
    stop("Package 'pROC' is required but not installed.")
  }
  
  # Input validation
  if (!is.data.frame(data)) {
    stop("'data' must be a data frame.")
  }
  
  if (!outcome_var %in% names(data)) {
    stop("The outcome variable is not present in the data.")
  }
  
  if (!all(predictor_vars %in% names(data))) {
    missing_vars <- predictor_vars[!predictor_vars %in% names(data)]
    stop("The following predictor variables are not present in the data: ",
         paste(missing_vars, collapse = ", "))
  }
  
  # Ensure outcome variable is a factor with appropriate levels
  if (!is.factor(data[[outcome_var]])) {
    data[[outcome_var]] <- factor(data[[outcome_var]], levels = c(neg_class, pos_class))
  } else if (!all(c(neg_class, pos_class) %in% levels(data[[outcome_var]]))) {
    data[[outcome_var]] <- factor(data[[outcome_var]], levels = c(neg_class, pos_class))
  }
  
  # Create the formula
  formula_str <- paste(outcome_var, "~", paste(predictor_vars, collapse = " + "))
  model_formula <- as.formula(formula_str)
  
  # Fit the logistic regression model
  model <- glm(model_formula, data = data, family = binomial())
  
  # Generate ROC curve
  actual_classes <- data[[outcome_var]]
  predicted_probs <- predict(model, type = "response")
  roc_curve <- pROC::roc(actual_classes, predicted_probs)
  
  # Return results
  return(list(
    model = model,
    roc_curve = roc_curve,
    formula = model_formula
  ))
}