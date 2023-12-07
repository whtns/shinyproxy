#!/usr/bin/env Rscript

library('tidyverse')
library('fs')
library('readxl')
library(chevreul)


seu <- readRDS("~/single_cell_projects/shinyproxy/dockerdata/Final_dataset_Clean_public_061223.rds")

seven_seq_bigwigs <- load_bigwigs(seu)

dir_create("~/single_cell_projects/shinyproxy/dockerdata/seven_seq_bigwigs")

seven_seq_bigwigs <-
  seven_seq_bigwigs %>%
  dplyr::mutate(new_path = fs::path("/dataVolume/storage/single_cell_projects/shinyproxy/dockerdata/seven_seq_bigwigs/", path_file(bigWig)))

purrr::map2(seven_seq_bigwigs$bigWig, seven_seq_bigwigs$new_path, file_copy, overwrite = TRUE)

# has new path of all files
bigwigfiles <- seven_seq_bigwigs$new_path


bigwig_db = "~/single_cell_projects/shinyproxy/dockerdata/bw-files.db"

#test_db = "~/single_cell_projects/shinyproxy/dockerdata/test.db"

bigwigfiles <- fs::path_abs(bigwigfiles)
bigwigfiles <- bigwigfiles %>%
  purrr::set_names(fs::path_file) %>%
  tibble::enframe(
    "name",
    "bigWig"
  ) %>%
  dplyr::mutate(sample_id = stringr::str_remove(name, "_Aligned.sortedByCoord.out.bw")) %>% # this line is the problem!
  identity()
con <- DBI::dbConnect(RSQLite::SQLite(), dbname = bigwig_db)
DBI::dbWriteTable(con, "bigwigfiles", bigwigfiles, overwrite = TRUE)
DBI::dbDisconnect(con)
test0 <- DBI::dbReadTable(con, "bigwigfiles")



tibble_test <- load_bigwigs(seu, "~/single_cell_projects/shinyproxy/dockerdata/bw-files.db")
all(sort(tibble_test$sample_id)==sort(colnames(seu)))
