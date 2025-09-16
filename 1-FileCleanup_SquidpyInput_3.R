library("tidyverse")

# Input dataset
setwd("/Volumes/JMTPass/MICSSS_i27_Liver_FOLR2macs/")
csv_fhandles <- list.files(path = "data/csv_files/", pattern = "i27d13_", full.names = TRUE)

# Cell ID and position in the tissue
id_cols <- c("Centroid X px", "Centroid Y px")

# Additional markers
summary_markers <- c("Cell_FOLR2_mean", "Cell_F480_mean")

# Define the main function
main <- function(csv_fhandle) {
  SAMPLE <- tools::file_path_sans_ext(basename(csv_fhandle))
  
  # Read in data with character columns
  pdat <- read_csv(csv_fhandle, show_col_types = FALSE) %>% 
    mutate(CellID = 1:n())
  
  # Determine cell_type based on marker values
  pdat <- pdat %>%
    mutate(
      cell_type = ifelse(`Cell_FOLR2_mean` > 80 & `Cell_F480_mean` > 70 , "FOLR2_Mac",
                         ifelse(`Cell_F480_mean` > 70 , "Mac",
                                ifelse(`Cell_FOLR2_mean` > 70, "FOLR2_other","other")
                                )
    ))
  
  # Bind and rename
  demuxed <- bind_cols(
    pdat[, c(id_cols, summary_markers, "cell_type")],  # Add "cell_type" here
  ) %>%
    rename(
      x = 1, 
      y = 2
    )  %>%
    mutate(y = max(y) - y) # Invert y-axis
  
  # Write output
  write.csv(demuxed, file.path("results", paste0(SAMPLE, ".csv")), row.names = FALSE)
}

# Loop over CSV files and apply the main function
lapply(csv_fhandles, main)
