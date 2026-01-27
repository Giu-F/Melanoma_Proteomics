# ==============================================================================
# SCRIPT: run_batch_timepoints_180_40_spd.R
# PURPOSE: Automatically generate QC reports for 2h and 6h timepoints
# LOCATION: Save this in your Project Root folder
# ==============================================================================

library(quarto)
library(here)

# 1. LIST YOUR FOLDERS HERE
folders_to_process <- c(
  "Prot_180spd_patient05_2h",
  "Prot_180spd_patient05_6h",
  "Prot_40spd_120K_2Th_patient05_6h",
  "Prot_40spd_120K_6Th_patient05_6h",
  "Prot_40spd_240K_2Th_patient05_6h"
)

# 2. START THE LOOP
for (folder in folders_to_process) {
  
  message(paste("\n================================================="))
  message(paste("🚀 Processing:", folder))
  message(paste("================================================="))
  
  # Check if data exists before trying to run
  if (!file.exists(here("data", "SILAC_Proteome", folder, "report.parquet"))) {
    message("❌ Skipped: report.parquet not found in folder: ", folder)
    next
  }
  
  # Define the output HTML filename
  html_name <- paste0("QC_Report_", folder, ".html")
  
  tryCatch({
    # Render the Template
    quarto_render(
      input = "analysis/04_SILAC_180_40_spd_tp_from_report.qmd",  # This must match the QMD filename
      output_file = html_name,
      execute_params = list(subfolder = folder)    # Passes the folder name to the QMD
    )
    
    message(paste("✅ Success! Report saved to: analysis/", html_name))
    
  }, error = function(e) {
    message(paste("❌ Error processing", folder, ":", e$message))
  })
}
    
    
    