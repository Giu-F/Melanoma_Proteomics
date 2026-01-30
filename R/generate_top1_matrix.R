#' Generate Top1 Phosphosite Matrix
#'
#' Pivots data to wide format and selects the single best precursor (highest sum)
#' for each phosphosite/channel combination.
#'
#' @param report_df The expanded dataframe (long format)
#' @return A list containing the full matrix and the filtered Top1 matrix
generate_top1_matrix <- function(report_df) {
  require(tidyverse)
  require(readr)
  
  message("--> Generating Wide Matrix and calculating Top1...")
  
  # 1. Pivot to Wide Format
  matrix_wide <- report_df %>%
    select(Precursor.Id, psite.id, Channel, id, Protein.Names, Genes, site_pos, window, Run, Precursor.Normalised) %>%
    pivot_wider(
      names_from = Run, 
      values_from = Precursor.Normalised
    )
  
  # 2. Identify Run Columns dynamically
  metadata_cols <- c("Precursor.Id", "psite.id", "Channel", "id", "Protein.Names", "Genes", "siten", "window")
  run_cols <- setdiff(names(matrix_wide), metadata_cols)
  
  # 3. Calculate Row Sums (Total Intensity of that precursor)
  # We use rowSums only on the run columns
  matrix_wide$total_intensity <- rowSums(matrix_wide[, run_cols], na.rm = TRUE)
  
  message("--> Wide Matrix created with ", nrow(matrix_wide), " precursors.")
  
  # 4. Filter for TOP1 Precursor
  # Group by Site + Channel -> Keep only the row with max intensity
  matrix_top1 <- matrix_wide %>%
    group_by(psite.id, Channel) %>%
    # slice_max automatically handles the "keep highest" logic
    # with_ties = FALSE takes the first one if exact tie (rare)
    slice_max(order_by = total_intensity, n = 1, with_ties = FALSE) %>%
    ungroup() %>%
    select(-total_intensity) # Remove helper column
  
  # 5. Quality Checks
  initial_rows <- nrow(matrix_wide)
  final_rows   <- nrow(matrix_top1)
  
  # Check uniqueness
  dupes <- sum(duplicated(matrix_top1[, c("psite.id", "Channel")]))
  
  message("--> Filtering Complete:")
  message("    Precursors (Start): ", initial_rows)
  message("    Unique Sites (End): ", final_rows)
  
  if(dupes == 0) {
    message("    SUCCESS: No duplicates found in final matrix.")
  } else {
    warning("⚠️ WARNING: Found ", dupes, " duplicates in psite.id/Channel combinations!")
  }
  
  return(matrix_top1)
}