"
Script to clean and preprocess the dataset.
Usage:
  02-clean_data.R --input=<input> --output=<output>

Options:
  --input=<input>   Path to raw dataset.
  --output=<output> Path to save cleaned dataset.
"

library(docopt)
library(readr)
library(incomepredictability)
library(pointblank)
library(dplyr)

# doc <- docopt("
# Usage:
#   02_clean_data.R --input=<input> --output=<output>
# ")
doc <- docopt::docopt("
Usage:
  02_clean_data.R --input=<input> --output=<output>
", args = c("--input", "/Users/benjogerochi/dsci310/dsci-310-group-8/data/raw/adult_raw.csv", "--output", "/Users/benjogerochi/dsci310/dsci-310-group-8/data/clean/adult_clean.csv")) #nolint

raw_data <- read_csv(doc$input, col_names = FALSE)
# Checklist #1: Correct Data File Format
if (!inherits(raw_data, "data.frame")) {
  stop("The input raw_data is not a data frame or tibble as expected!")
}

# Create a pointblank agent for the raw data with action levels that automatically stop on failure. #nolint
raw_agent <- create_agent(
  tbl = raw_data,
  tbl_name = "Raw Data",
  actions = action_levels(warn_at = 1, stop_at = 50, notify_at = 1)
) %>%
  # Checklist #2: Correct column names (raw data headers are X1, X2, ..., X15) #nolint
  col_exists(columns = paste0("X", 1:15)) %>%
  # Checklist #3: No empty observations (checks for completely NA rows)
  rows_complete()

# Checklist #4: Missingness not beyond expected threshold (set to 95%)
# Can't use col_vals_not_null() yet--might have some missingness in the raw data
missing_thresholds <- raw_data %>%
  summarise(across(everything(), ~ sum(!is.na(.)) / n()))
if (!all(missing_thresholds >= 0.95)) {
  stop("One or more columns do not meet the 95% non-missing threshold.")
}

# Checklist #5: Correct column data types (expected types based on spec)
raw_agent <- raw_agent %>%
  col_is_numeric(columns = vars(X1, X3, X5, X11, X12, X13)) %>%
  col_is_character(columns = vars(X2, X4, X6, X7, X8, X9, X10, X14, X15)) %>%
  # Checklist #6: No duplicate observations
  # Duplicate row validation failed, but after investigation these observations were deemed distinct
  # Hence we will increase the stopping threshold so it only warns rather than stops the workflow
  rows_distinct() %>%
  # Checklist #7: No outliers or anomalous values
  col_vals_between(columns = vars(X1), left = 0, right = 100) %>% # age (X1): 0-100
  col_vals_between(columns = vars(X3), left = 1, right = Inf) %>%   # fnlwgt (X3): positive
  col_vals_between(columns = vars(X5), left = 1, right = 16) %>% # education_num (X5): 1-16
  col_vals_between(columns = vars(X11), left = 0, right = Inf) %>% # capital_gain (X11): 0 or positive
  col_vals_between(columns = vars(X12), left = 0, right = Inf) %>% # capital_loss (X12): 0 or positive
  col_vals_between(columns = vars(X13), left = 1, right = 100) %>% # hours_per_week (X13) 1-100

  # Checklist #8a: Correct category levels (i.e., no string mismatches; within the allowed set)
  # Check for workclass values (X2)
  col_vals_in_set(
    columns = vars(X2),
    set = c(
      "State-gov", "Self-emp-not-inc", "Private", "Federal-gov",
      "Local-gov", "?", "Self-emp-inc", "Without-pay", "Never-worked" # has a ?, will re-validate after cleaning
    ),
    label = "Workclass values check"
  ) %>%
  # Check for education values (X4)
  col_vals_in_set(
    columns = vars(X4),
    set = c(
      "Bachelors", "HS-grad", "11th", "Masters", "9th", "Some-college",
      "Assoc-acdm", "Assoc-voc", "7th-8th", "Doctorate", "Prof-school",
      "5th-6th", "10th", "1st-4th", "Preschool", "12th"
    ),
    label = "Education values check"
  ) %>%
  # Check for marital-status values (X6)
  col_vals_in_set(
    columns = vars(X6),
    set = c(
      "Never-married", "Married-civ-spouse", "Divorced", "Married-spouse-absent",
      "Separated", "Married-AF-spouse", "Widowed"
    ),
    label = "Marital status values check"
  )

# unique_values <- unique(raw_data$X6)
# print(unique_values)

duplicates <- raw_data[duplicated(raw_data), ]
print(duplicates)

# Run the interrogation (this evaluates all the above checks)
raw_agent <- interrogate(raw_agent)
raw_agent

clean_data <- na.omit(raw_data)
colnames(clean_data) <- c(
  "age", "workclass", "fnlwgt", "education", "education_num",
  "marital_status", "occupation", "relationship", "race", "sex", "capital_gain", # nolint
  "capital_loss", "hours_per_week", "native_country", "income"
)
clean_data$income <- as.factor(clean_data$income)

write.csv(clean_data, doc$output, row.names = FALSE)
message("Dataset cleaned successfully.")
