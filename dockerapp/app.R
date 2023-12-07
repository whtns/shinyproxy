#!/usr/bin/env Rscript

library(tidyverse)
library(shiny)
library(shinydashboard)
library(SingleCellExperiment)
library(ggraph)
library(formattable)
library(clustree)
library(fs)
library(chevreul)
library(InteractiveComplexHeatmap)
library(shinyFiles)
# 
# seu <- readRDS("~/single_cell_projects/integrated_projects/7-seq_050120/output/seurat/unfiltered_seu.rds")
seu <- readRDS("/root/dockerdata/Final_dataset_Clean_public_061223.rds")

dockerSeuratApp(seu, bigwig_db="/root/dockerdata/bw-files.db")
# minimalSeuratApp(seu)
