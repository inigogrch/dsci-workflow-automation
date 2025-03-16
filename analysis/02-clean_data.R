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

doc <- docopt("
Usage:
  02_clean_data.R --input=<input> --output=<output>
")

data <- read_csv(doc$input, col_names = FALSE)
data <- na.omit(data)
colnames(data) <- c("age", "workclass", "fnlwgt", "education", "education_num",
"marital_status", "occupation", "relationship", "race", "sex", "capital_gain",  # nolint
"capital_loss", "hours_per_week", "native_country", "income")
data$income <- as.factor(data$income)

write.csv(data, doc$output, row.names = FALSE)
message("Dataset cleaned successfully.")