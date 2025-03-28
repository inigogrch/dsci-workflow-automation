# R/train_test_split.R

#' Split a data frame into training and testing subsets
#'
#' @param data A data frame or tibble to be split into training and testing subsets
#' @param train_fraction A numeric value between 0 and 1 specifying the fraction of rows for training
#' @return A list containing two elements:
#'   \item{train}{The training subset as a data frame}
#'   \item{test}{The testing subset as a data frame}
#' @export
#'
#' @examples
#' # Given an existing data frame called df
#' # result <- train_test_split(df, 0.8)
#' # head(result$train)  
#' # head(result$test)   
train_test_split <- function(data, train_fraction = 0.8) {
  set.seed(1234)
  train_indices <- sample(
    seq_len(nrow(data)),
    size = floor(train_fraction * nrow(data))
  )
  
  train_data <- data[train_indices, ]
  test_data <- data[-train_indices, ]
  
  list(
    train = train_data,
    test = test_data
  )
}
