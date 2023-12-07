library(shiny)
library(Rmpfr)
library(wiggleplotr)
library(tidyverse)


shinyServer(function(input, output){
      
 
      output$wiggleplot <- renderPlot({
            
            precisionBits <- input$precision
            one <- mpfr(1, precBits = precisionBits) 
            e <- exp(one)
            # TODO fix printing...
            x <- capture.output(print(e, ndigits = precisionBits))[2]
            
            
            bigwigdb = "/root/dockerdata/bw-files.db"
            
            con <- DBI::dbConnect(RSQLite::SQLite(), bigwigdb)
            
            bigwig_tbl <- DBI::dbReadTable(con, "bigwigfiles")
            
            seu <- readRDS("/root/dockerdata/Final_dataset_Clean_public_061223.rds")
            
            cell_metadata <- seu@meta.data
            
            cell_metadata["sample_id"] <- NULL
            
            # mybigwigfile = fs::path("/root/dockerdata/seven_seq_bigwigs", mytable[1,1])
            # message(file.exists(mybigwigfile))
            # plyranges::read_bigwig(mybigwigfile)
            
            edb <- EnsDb.Hsapiens.v86::EnsDb.Hsapiens.v86
            genes_of_interest = "RXRG"
            
            new_track_data <-
            	cell_metadata %>%
            	tibble::rownames_to_column("sample_id") %>%
            	dplyr::select(sample_id,
            				  condition = "batch",
            				  track_id = "batch",
            				  colour_group = "batch",
            				  everything()
            	) %>%
            	dplyr::mutate(scaling_factor = 1) %>% # scales::rescale(nCount_RNA)
            	dplyr::mutate(condition = as.factor(condition), colour_group = as.factor(colour_group)) %>%
            	dplyr::left_join(bigwig_tbl, by = "sample_id") %>%
            	dplyr::filter(!is.na(bigWig)) %>%
            	identity()
            
            # message(new_track_data)
            
            heights = c(3,1)
            
            start = NULL
            end = NULL
            
            if (is.null(start) | is.null(end)) {
            	region_coords <- NULL
            } else {
            	region_coords <- c(start, end)
            }
            
            wiggleplotr::plotCoverageFromEnsembldb(
            	ensembldb = edb,
            	gene_names = genes_of_interest,
            	track_data = new_track_data,
            	heights = heights,
            	alpha = 0.5,
            	fill_palette = scales::hue_pal()(length(levels(new_track_data$colour_group))),
            	return_subplots_list = FALSE
            )
            
            # gsub("^\\[1\\] (.+)$", "\\1", x)
            
            
            
          })
      
    })
