#' Clean and Filter DIA-NN Report
#'
#' @param report_path Path to the report.parquet file
#'
#' @return A cleaned data.table
clean_diann_data <- function(report_path) {
  require(arrow)
  require(data.table)
  require(dplyr)
  
  message("--> Loading parquet file: ", report_path)
  report <- arrow::read_parquet(report_path)
  data.table::setDT(report)
  
  initial_rows <- nrow(report)
  
  # 1. Remove Contaminants (cRAP)
  report <- report[!Protein.Group %like% "cRAP"]
  
  # 2. Remove rows with missing Gene name
  report <- report[Genes != ""]
  
  # 3. Remove rows with 0 quantification
  report <- report[PG.MaxLFQ != 0]
  
  # 4. Filter Quality (PG.MaxLFQ.Quality >= 0.7)
  report <- report[PG.MaxLFQ.Quality >= 0.7]
  
  # 5. Remove rows with missing Channel
  report <- report[Channel != ""]
  
  # 6. Filter Q-Values
  report <- report[PG.Q.Value <= 0.05]
  report <- report[Lib.PG.Q.Value <= 0.01]
  
  message("--> Cleaning Complete. Reduced from ", initial_rows, " to ", nrow(report), " rows.")
  
  return(report)
}