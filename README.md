# The Proteomics and Phosphoproteomics Landscape of Melanoma Under T Cell Attack

![License](https://img.shields.io/github/license/Giu-F/Melanoma_Proteomics)
![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Status](https://img.shields.io/badge/status-active-success)

**A simplified, interactive web interface and reproducible analysis pipeline for complex proteomics datasets.**

Developed by **Giulia Franciosa**, PhD  
*Jesper V. Olsen Lab, CPR, University of Copenhagen*

🔗 **[View Live Application](https://giu-f.github.io/Melanoma_Proteomics/)**

---

## 📖 Overview
This project contains the source code and analysis pipeline for the study *"The Proteomics and Phosphoproteomics Landscape of Melanoma Under T Cell Attack"*. It serves two main purposes:

1.  **Interactive Visualization:** A single-page web application (SPA) to visualize protein expression levels and phosphorylation sites in patient-derived melanoma cell lines upon T cell attack.
2.  **Reproducible Analysis:** The complete R/Quarto code used to generate the statistical results and figures presented in the publication.

<img width="1219" alt="Application Screenshot" src="https://github.com/user-attachments/assets/3c4b3dab-1886-433b-a149-c8b596e86bcd" />

*(Screenshot of the visualization interface)*

---
### 📄 Read the Pre-print
**[The Proteomics and Phosphoproteomics Landscape of Melanoma Under T Cell Attack](https://doi.org/10.1101/2025.09.12.675787)**  
*Available now on bioRxiv* 🔬

---

## 🔒 Data Availability

The raw mass spectrometry proteomics data have been deposited to the ProteomeXchange Consortium via the PRIDE partner repository with the dataset identifier:

**PXD068403** (EGF Stimulation Dataset)  
**PXD068582** (Melanoma Co-culture Dataset)  
**PXD068650** (IFNG Stimulation Dataset)

> **⚠️ Note on Access:** The raw data are currently **private/under embargo** and will be released publicly upon peer-reviewed publication. The code in this repository is shared for transparency and peer review. Once the data is released, you can place the files in the `data/` folder to fully reproduce the analysis.

---

## 💻 Reproducible Analysis Pipeline

We provide a modular R workflow to process the MaxQuant output, perform normalization, and generate the figures.

### Repository Structure
* **`analysis/`**: Contains the main Quarto analysis notebooks (.qmd).
* **`R/`**: Custom helper functions for data loading and visualization.
* **`data/`**: Place raw input files here (see Data Availability).
* **`results/`**: Output tables and intermediate files (ignored by Git).

### 🛠️ Prerequisites
Before running the code, ensure you have the following installed:
* [R](https://cran.r-project.org/) (v4.0 or higher recommended)
* [RStudio Desktop](https://posit.co/download/rstudio-desktop/)
* [Git](https://git-scm.com/downloads) (Required to download the code)

### 🚀 How to Run the Analysis

**1. Get the Code (Clone)**
The easiest way is to use RStudio:
* Open RStudio.
* Go to **File > New Project > Version Control > Git**.
* In the "Repository URL" box, paste:
  `https://github.com/Giu-F/Melanoma_Proteomics.git`
* Click **Create Project**.

**2. Install Dependencies**
This project uses a `DESCRIPTION` file to ensure you have the exact packages needed. Run this command in the RStudio **Console**:
```r
# Install the devtools package if you don't have it
if (!require("devtools")) install.packages("devtools")

# Install all project dependencies
devtools::install_deps()
```
3.  **Run the Report:**
    * Open the Quarto analysis file.
    * Click the **Render** button in RStudio.
    * The final HTML report will be generated in the `analysis/` folder.

---

## ✨ Web App Key Features

### 🧬 Dual Dataset Support
* **Proteome (6h):** Visualizes protein expression data after 6 hours.
* **Phospho (2h):** Visualizes phosphorylation site data after 2 hours.
* **Tabbed Interface:** Toggle between datasets instantly.

### 🔍 Interactive Search & Visualization
* **Smart Search:** Search by **Gene Name** or **Protein ID**.
* **Multi-Plot Phospho View:** Dynamically generates separate plots for every unique phosphosite associated with a searched gene.
* **Statistical Overlays:** Displays Limma statistical results (logFC, P.Value, adj.P.Val, Regulation) directly above each chart.

### 📊 Advanced Visualization (Plotly.js)
* **Faceted Charts:** Data is split into 3 subplots based on experimental SILAC "Channel" (L, M, H).
* **Grouped Comparison:** Clear distinction between **Control** (Dark Blue) and **Co-culture** (Dark Red).
* **Patient Tracking:** Bar charts show mean expression; scatter overlays show individual biological replicates.
* **Dynamic Scaling:** Y-axes automatically "zoom in" on the data range to highlight subtle biological differences.

---

## 🛠️ Web App Technical Stack
The application runs entirely client-side (no backend server required).

* **Framework:** React 18
* **Visualization:** Plotly.js
* **Data Parsing:** PapaParse (CSV/TSV) & JSZip (Compression)
* **Styling:** Tailwind CSS
* **Icons:** Lucide-React

---

## 🚀 Deployment & Data Updates

This application is hosted via **GitHub Pages**. Because it is a static site, the data lives in the repository alongside the code.

---

## 📜 License
Distributed under the **MIT License**. See `LICENSE` for more information.

## 📬 Contact & Credits
**Giulia Franciosa, PhD**

**Jesper V. Olsen Lab** Novo Nordisk Foundation Center for Protein Research (CPR)  
University of Copenhagen
