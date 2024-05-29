#!/usr/bin/env Rscript

library(tidyverse)
library(shiny)
library(shinydashboard)
library(SingleCellExperiment)
library(ggraph)
library(formattable)
library(clustree)
library(fs)
library(seuratTools)
library(InteractiveComplexHeatmap)
library(shinyFiles)
# 

# seu <- readRDS("/dataVolume/storage/single_cell_projects/shinyproxy/dockerdata/Final_dataset_Clean_public_061223.rds")
seu <- readRDS("/root/dockerdata/Final_dataset_Clean_public_061223.rds")

# dockerSeuratApp(seu, bigwig_db="/root/dockerdata/bw-files.db")
minimalSeuratApp(seu)
