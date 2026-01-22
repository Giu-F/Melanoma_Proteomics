
#' Plot Volcano for a specific contrast
#' @param limma_data The data frame containing limma results
#' @param contrast_name The string name of the contrast (e.g., "IL", "PBS")
#' @param gene_list A vector of genes to highlight (e.g., ERBB2 pathway genes)
plot_volcano <- function(limma_data, contrast_name, gene_list) {
  
  # Filter data for the specific contrast
  subset_data <- limma_data %>% 
    filter(contrast == contrast_name)
  
  # Highlight specific genes
  kegg_hits <- subset_data %>% 
    filter(regulated != "Unchanged") %>% 
    filter(Gene.Names %in% gene_list)
  
  # Plot
  ggplot(subset_data, aes(x = logFC, y = -log(adj.P.Val, 10))) +
    geom_point(aes(fill = regulated, alpha = regulated), 
               size = 2.5, shape = 21, color = "black") +
    scale_alpha_manual(values = c("Up-regulated" = 0.8, "Down-regulated" = 0.8, "Unchanged" = 0.2)) +
    scale_fill_manual(values = c("Up-regulated" = "#e41a1c", "Down-regulated" = "#377eb8", "Unchanged" = "#4daf4a")) +
    geom_text_repel(data = kegg_hits, 
                    aes(label = id), 
                    max.overlaps = Inf, size = 2, box.padding = 0.4) +
    geom_hline(yintercept = -log10(0.01), linetype = "dotted", col = "black", linewidth = 1) +
    labs(x = "Log2FC EGF vs Ctrl", y = "-Log10 adjusted p", title = contrast_name) +
    theme_minimal(base_size = 12)
}