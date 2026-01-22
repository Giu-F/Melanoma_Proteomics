#' Plot Specific PTM-SEA Signature
#'
#' @param data The PTM-SEA results dataframe
#' @param sig_id The exact string ID of the signature (e.g., "PERT-PSP_EGF")
#' @param title The title for the plot
#' @param y_limit (Optional) A vector c(min, max) for the y-axis
#'
#' @return A ggplot object
plot_signature <- function(data, sig_id, title, y_limit = NULL) {
  
  # Filter for the specific signature
  subset_data <- data %>% 
    dplyr::filter(`Signature ID` == sig_id)
  
  # Check if data exists
  if (nrow(subset_data) > 0) {
    p <- ggplot2::ggplot(subset_data, ggplot2::aes(x = contrast, y = Score, fill = adj_pval)) +
      ggplot2::geom_bar(stat = "identity") +
      # Use viridis for color scale (direction = -1 makes smaller p-values darker/more intense)
      viridis::scale_fill_viridis(option = "C", direction = -1) + 
      ggplot2::geom_text(ggplot2::aes(label = round(Score, 2)), vjust = -0.5) +
      ggplot2::theme_minimal(base_size = 14) +
      ggplot2::xlab("") + 
      ggplot2::ylab("Score") +
      ggplot2::ggtitle(title)
    
    # Apply y-limits if provided
    if (!is.null(y_limit)) {
      p <- p + ggplot2::ylim(y_limit[1], y_limit[2])
    }
    
    print(p)
    
  } else {
    message(paste("Signature not found in results:", sig_id))
  }
}