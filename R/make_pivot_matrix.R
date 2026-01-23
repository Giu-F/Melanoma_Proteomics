#' Create Wide Matrix from Long Report (High Performance)
#'
#' @param data The cleaned data.table
#' @param value_var The column to use for values (default: "PG.MaxLFQ")
#'
#' @return A wide format data.table
make_pivot_matrix <- function(data, value_var = "PG.MaxLFQ") {
  require(data.table)
  
  # Ensure it is a data.table
  if (!is.data.table(data)) setDT(data)
  
  # 1. Select only necessary columns
  # (Using ..var notation to tell data.table to use the variable's value)
  cols_to_keep <- c("Run", "Channel", "Protein.Group", "Protein.Names", "Genes", value_var)
  
  # unique() removes duplicates
  data_subset <- unique(data[, ..cols_to_keep])
  
  # 2. Pivot to Wide Format using data.table::dcast
  # Formula: Rows (Protein Info) ~ Columns (Run)
  matrix_wide <- dcast(
    data_subset, 
    Protein.Group + Protein.Names + Genes + Channel ~ Run, 
    value.var = value_var,
    fill = 0  # Fills missing values with 0 (Standard for MaxLFQ)
  )
  
  return(matrix_wide)
}