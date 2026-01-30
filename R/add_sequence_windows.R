#' Add UniProt Sequences and Extract Windows
#'
#' @param report The dataframe containing 'id' and 'site' columns
#' @param window_size Number of AA to extract before/after site (default 5)
#' @return Dataframe with 'sequence' and 'window' columns
add_sequence_windows <- function(report, window_size = 5) {
  require(protti)
  require(tidyverse)
  require(stringr)
  
  # 1. Fetch UniProt Sequences
  unique_ids <- unique(report$id)
  message("--> Fetching sequences for ", length(unique_ids), " unique proteins...")
  
  # Fetch data (wrapped in tryCatch to handle API errors safely)
  uniprot_data <- tryCatch({
    fetch_uniprot(
      unique_ids,
      columns = "sequence",
      batchsize = 50,
      show_progress = TRUE
    )
  }, error = function(e) {
    warning("⚠️ UniProt fetch failed: ", e$message)
    return(NULL)
  })
  
  if (is.null(uniprot_data)) return(report)
  
  # Clean UniProt data
  uniprot_data <- uniprot_data %>% 
    select(accession, sequence) %>%
    filter(!is.na(sequence))
  
  # 2. Join Sequence to Report
  report <- left_join(report, uniprot_data, by = c("id" = "accession"))
  
  # 3. Extract Numeric Position
  # Remove S, T, Y to get the number (e.g. "S10" -> 10)
  report$site_pos <- as.numeric(gsub("[STY]", "", report$site))
  
  # 4. Extract Window (Vectorized Speed Up)
  message("--> Extracting sequence windows +/- ", window_size, " AA...")
  
  # We only process rows where we successfully got a sequence
  valid_idx <- which(!is.na(report$sequence) & !is.na(report$site_pos))
  
  if(length(valid_idx) > 0) {
    # Get vectors for calculation
    seqs <- report$sequence[valid_idx]
    pos  <- report$site_pos[valid_idx]
    len  <- nchar(seqs)
    
    # Calculate start/end with boundaries (so we don't go < 1 or > length)
    starts <- pmax(1, pos - window_size)
    ends   <- pmin(len, pos + window_size)
    
    #Process all rows at once
    report$window[valid_idx] <- substr(seqs, starts, ends)
  } else {
    report$window <- NA
  }
  
  message("--> Sequence annotation complete.")
  return(report)
}