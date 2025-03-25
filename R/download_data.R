# R/download_data.R

#' Download a dataset from a URL and save it locally
#'
#' @param url A string specifying the URL of the dataset
#' @param output A string specifying the local file path to save the dataset
#' @return No return value, called for side effects (saves file locally)
#' @examples
#' download_data("https://example.com/data.csv", "data/adult.csv")

download_data <- function(url, output) {
  download.file(url, output, mode = "wb")
  message("Dataset downloaded successfully.")
}