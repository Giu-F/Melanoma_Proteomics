#' Expand Phospho-sites (Optimized for Max 3)
expand_phospho_report <- function(report) {
  require(tidyverse)
  require(stringr)
  require(data.table)
  
  message("--> Expanding Phospho-sites...")
  
  # 1. Clean ID and Sites string
  # Vectorized regex is instant compared to sub/gsub loops
  report$id <- sub(":.*", "", report$Protein.Sites)
  report$id <- gsub("\\[", "", report$id)
  
  report$sites <- sub(".*:", "", report$Protein.Sites)
  report$sites <- gsub("]", "", report$sites)
  
  # 2. Extract Site Probabilities (Vectorized)
  # Extracts all numbers after "(UniMod:21){"
  # This returns a LIST of vectors for each row
  probs_list <- str_extract_all(report$Site.Occupancy.Probabilities, "(?<=\\(UniMod:21\\)\\{)\\d+\\.\\d+")
  
  # 3. Filter STY Sites
  # We use a helper to keep only S, T, or Y sites from the comma-separated string
  filter_STY_vec <- function(s) {
    parts <- strsplit(s, ",")[[1]]
    paste(parts[grep("^[STY]", parts)], collapse = ",")
  }
  # Apply filter
  report$sty <- sapply(report$sites, filter_STY_vec)
  
  # 4. Count Phosphos per precursor
  report$pcount <- str_count(report$Precursor.Id, "UniMod:21")
  
  # 5. Split into Columns (Max 3)
  # separate_wider_delim is the modern, fast replacement for separate()
  # It automatically fills missing columns with NA
  report_expanded <- report %>%
    separate_wider_delim(
      sty, 
      delim = ",", 
      names = c("site1", "site2", "site3"), 
      too_few = "align_start", 
      cols_remove = FALSE
    ) 
  
  # Add probabilities manually because separate() doesn't handle list columns easily
  # We extract the 1st, 2nd, 3rd element of the probability list
  report_expanded$prob1 <- sapply(probs_list, function(x) as.numeric(x[1]))
  report_expanded$prob2 <- sapply(probs_list, function(x) as.numeric(x[2]))
  report_expanded$prob3 <- sapply(probs_list, function(x) as.numeric(x[3]))
  
  # 6. Pivot Longer (The Clean Alternative to rbind(r1, r2, r3))
  # This takes the 3 sets of columns and stacks them automatically
  final_df <- report_expanded %>%
    pivot_longer(
      cols = matches("site[1-3]|prob[1-3]"),
      names_to = c(".value", "site_num"),
      names_pattern = "(site|prob)(\\d)" 
    ) %>%
    rename(site = site, loc.prob = prob) %>%
    
    # Remove empty rows (where site was NA because the peptide had <3 sites)
    filter(!is.na(site)) %>%
    
    # 7. Final Cleanup
    mutate(
      loc.prob = replace_na(loc.prob, 0),
      psite.id = paste0(id, ":", site, "_M", pcount)
    )
  
  message("--> Expansion Complete.")
  return(final_df)
}