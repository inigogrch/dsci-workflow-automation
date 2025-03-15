"
Script to create our training set from the raw data
Usage:
  03-training_split.R --input=<input>
  --output_train=<output> --output_test=<output>

Options:
  --input=<input>   Path to cleaned dataset.
  --output_train=<output> Path to save training dataset.
  --output_test=<output> Path to save testing dataset
"

library(docopt)
library(dplyr)
library(readr)

doc <- docopt("
Usage:
  03-training_split.R --input=<input>
  --output_train=<output> --output_test=<output>
")

set.seed(1234)

cleaned_data <- read_csv(doc$input)
sample_size <- round(0.1 * nrow(cleaned_data))
income_sample <- cleaned_data %>%
  sample_n(size = sample_size)

train_indices <- sample(seq_len(nrow(income_sample)),
  size = 0.8 * nrow(income_sample)
)
train_data <- income_sample[train_indices, ]
test_data <- income_sample[-train_indices, ]

write.csv(train_data, doc$output_train, row.names = FALSE)
write.csv(test_data, doc$output_test, row.names = FALSE)
message("Dataset split successfully.")
