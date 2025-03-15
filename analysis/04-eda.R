"
Script to perform exploratory data analysis (EDA).
Usage:
  analysis/04-eda.R --input=<input> --output_plot=<output> --output_table=<output> 

Options:
  --input=<input>   Path to cleaned training dataset.
  --output_plot=<output> Path to save visualization.
  --output_table=<output> Path to save summary table.
"

library(docopt)
library(ggplot2)
library(readr)
library(GGally)
library(tidyverse)
library(repr)

doc <- docopt("
Usage:
  analysis/04-eda.R --input=<input> --output_plot=<output> --output_table=<output>
")
train_data <- read_csv(doc$input) %>%
  select(-fnlwgt, -education, -relationship, -workclass, -capital_gain,
         -capital_loss, -marital_status, -occupation, -race, -sex,
         -native_country)

# Plot abstraction
options(repr.plot.width = 10, repr.plot.height = 8)
continuous_data <- train_data %>%
  select(age, hours_per_week, education_num)
pairs_plot <- ggpairs(continuous_data) +
  theme(
    text = element_text(size = 15),
    plot.title = element_text(face = "bold"),
    axis.title = element_text(face = "bold")
  )
ggsave(doc$output_plot, plot = pairs_plot)

# Summary stats abstraction
continuous_summary <- train_data %>%
  select(age, hours_per_week, education_num) %>%
  pivot_longer(cols = everything()) %>%
  group_by(name) %>%
  summarise(
    mean = mean(value, na.rm = TRUE),
    sd = sd(value, na.rm = TRUE),
    median = median(value, na.rm = TRUE),
    variance = var(value, na.rm = TRUE),
    max = max(value, na.rm = TRUE),
    min = min(value, na.rm = TRUE),
    .groups = "drop"
  )
write_csv(continuous_summary, doc$output_table)

message("EDA completed successfully.")