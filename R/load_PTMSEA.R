#' Load and Clean PTM-SEA Data
#'
#' @param filepath The path to the CSV file
#' @param label The name of the contrast (e.g., "IL")
#'
#' @return A cleaned data frame
load_ptm_data <- function(filepath, label) {
  df <- data.table::fread(filepath) 
  df <- as.data.frame(df)
  
  # Clean column names
  colnames(df) <- gsub(" \\(.*?\\)", "", colnames(df)) 
  colnames(df) <- gsub("adj p-val", "adj_pval", colnames(df))
  
  # Add label
  df$contrast <- label
  
  return(df)
}