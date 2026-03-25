
#' Expand Phospho-sites (Optimized for Max 2)
expand_phospho_report <- function(report) {
  require(tidyverse)
  require(stringr)
  require(data.table)
  
  message("--> Expanding Phospho-sites...")
  
  # 1. Clean ID and Sites string
  report$id <- sub(":.*", "", report$Protein.Sites)
  report$id <- gsub("\\[", "", report$id)
  
  report$sites <- sub(".*:", "", report$Protein.Sites)
  report$sites <- gsub("]", "", report$sites)
  
  head(report[, c("id", "sites")])
  
  # 2. Extract Site Probabilities (Vectorized)
  # Extracts all numbers after "(UniMod:21){"
  # This returns a LIST of vectors for each row
  probs_list <- str_extract_all(report$Site.Occupancy.Probabilities, "(?<=\\(UniMod:21\\)\\{)\\d+\\.\\d+")
  
  # 3. Filter STYA Sites
  # We use a helper to keep only S, T, Y and A sites from the comma-separated string
  filter_STYA_vec <- function(s) {
    parts <- strsplit(s, ",")[[1]]
    paste(parts[grep("^[STYA]", parts)], collapse = ",")
  }
  # Apply filter
  report$stya <- sapply(report$sites, filter_STYA_vec)
  
  head(report[, c("sites", "stya")])
  
  # 4. Count Phospho per precursor
  report$pcount <- str_count(report$Precursor.Id, "UniMod:21")
  
  head(report[, c("Precursor.Id", "pcount")])
  
  # 5. Split into Columns (Max 2)
  report_expanded <- report %>%
    separate_wider_delim(
      stya, 
      delim = ",", 
      names = c("site1", "site2"), 
      too_few = "align_start",
      cols_remove = FALSE
    )
  
  head(report_expanded[, c("stya", "site1", "site2")])
  
  # Add probabilities manually because separate() doesn't handle list columns easily
  # We extract the 1st, 2nd, 3rd element of the probability list
  report_expanded$prob1 <- sapply(probs_list, function(x) as.numeric(x[1]))
  report_expanded$prob2 <- sapply(probs_list, function(x) as.numeric(x[2]))
  
  head(report_expanded[, c("Site.Occupancy.Probabilities", "prob1", "prob2")])
  
  # 6. Pivot Longer
  # This takes the 2 sets of columns and stacks them automatically
  final_df <- report_expanded %>%
    pivot_longer(
      cols = matches("site[1-2]|prob[1-2]"),
      names_to = c(".value", "site_num"),
      names_pattern = "(site|prob)(\\d)" 
    ) %>%
    rename(site = site, loc.prob = prob) %>%
    
    # Remove empty rows (where site was NA because the peptide had <2 sites)
    filter(!is.na(site)) %>%
    
    # 7. Final Cleanup
    mutate(
      loc.prob = replace_na(loc.prob, 0),
      psite.id = paste0(id, ":", site, "_M", pcount)
    )
  
  head(final_df[, c("id", "site", "loc.prob", "pcount", "psite.id")])
  
  message("--> Expansion Complete.")
  return(final_df)
}