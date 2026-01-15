# The Proteomics and Phosphoproteomics Landscape of Melanoma Under T Cell Attack

![License](https://img.shields.io/github/license/Giu-F/Melanoma_Proteomics)
![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Status](https://img.shields.io/badge/status-active-success)

**A simplified, interactive web interface for visualizing complex proteomics datasets.**

Developed by **Giulia Franciosa, PhD** *Jesper V. Olsen Lab, CPR, University of Copenhagen*

🔗 **[View Live Application](https://giu-f.github.io/Melanoma_Proteomics/)**

---

## 📖 Overview
This project is a single-page web application (SPA) designed to visualize protein expression levels and phosphorylation sites in patient-derived melanoma cell lines under T cell attack by autologous Tumor-Infiltrating Lymphocytes (TILs).

The tool allows researchers to interactively explore the differences between **Co-culture** and **Control** groups, seamlessly toggling between proteome and phosphoproteome datasets without needing to install R or Python environments.

<img width="1219" alt="Application Screenshot" src="https://github.com/user-attachments/assets/3c4b3dab-1886-433b-a149-c8b596e86bcd" />

*(Screenshot of the visualization interface)*

---
### 📄 Read the Pre-print
**[The Proteomics and Phosphoproteomics Landscape of Melanoma Under T Cell Attack](https://doi.org/10.1101/2025.09.12.675787)** *Available now on bioRxiv* 🔬

---

## ✨ Key Features

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

## 🛠️ Technical Stack
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
**Giulia Franciosa, PhD** [Link to your LinkedIn or ResearchGate]

**Jesper V. Olsen Lab** Novo Nordisk Foundation Center for Protein Research (CPR)  
University of Copenhagen
