#' Clean and Filter DIA-NN Report for phospho
#'
#' @param report_path Path to the report.parquet file
#'
#' @return A cleaned data.table
clean_diann_phos_data <- function(report_path) {
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
  report <- report[Precursor.Normalised > 0]
  
  # 4. Filter Quality (Quantity.Quality >= 0.5)
  report <- report[Quantity.Quality >= 0.5]
  
  # 5. Remove rows with missing Channel
  report <- report[Channel != ""]
  
  # 6. Filter Q-Values
  report <- report[PG.Q.Value <= 0.05]
  report <- report[Lib.PG.Q.Value <= 0.01]
  report <- report[Lib.Peptidoform.Q.Value <= 0.01]
  report <- report[Channel.Q.Value <= 0.01]
  
  # 7. Count number of unique precursor_channel ids
  tot <- length(unique(paste0(report$Precursor.Id, report$Channel)))
  
  # 8. Keep phosphoprecursors
  report <- report[grepl("UniMod:21", Modified.Sequence, fixed=T),]
  
  # 9. Calculate phospho-enrichment efficiency %
  phos <- length(unique(paste0(report$Precursor.Id, report$Channel)))
  
  # 10. Print Efficiency
  cat("--> Phospho-enrichment efficiency:", round((phos / tot) * 100, 2), "%\n")
  
  # 11. Print Summary
  cat("--> Cleaning Complete. Reduced from", initial_rows, "to", nrow(report), "rows.\n")
  
  return(report)
}
