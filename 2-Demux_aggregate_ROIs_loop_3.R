# Aggregation of cell_types across ROIs

library(dplyr)
library(readr)
library(stringr)
library(tidyverse)

# Define paths for batch1 and batch2
result_folder <- c("../data/results/")

# Get a list of all CSV files in both batch1 and batch2
csv_fhandles_delta <- lapply(result_folder, function(folder) {
  list.files(path = folder, pattern = ".csv", full.names = TRUE)
})

# Flatten the list of file paths
csv_fhandles_delta <- unlist(csv_fhandles_delta)
tally_demux <- function(fhandle) {
  read_csv(fhandle, show_col_types = FALSE) %>% 
    group_by(cell_type) %>% 
    summarize(n = n()) %>%
    mutate(sample = str_remove(basename(fhandle), ".csv"))
}

counts_sample <- purrr::map_df(csv_fhandles_delta, tally_demux)

meta <- read_csv("../data/metadata.csv")

counts_sample <- rename(counts_sample, sample_id = sample)
counts_sample <- counts_sample %>% left_join(meta, by = "sample_id")
counts_by_line_ext <- counts_sample %>% 
  group_by(cell_type, mouse) %>%
  summarise(lesions_pr_mouse = mean(n)) %>% 
  pivot_wider(names_from = mouse, values_from = lesions_pr_mouse)

counts_sample_wide <- counts_sample %>% 
  group_by(cell_type, mouse,) %>% 
  summarise(lesions_pr_mouse = mean(n)) %>% 
  pivot_wider(names_from = mouse, values_from = lesions_pr_mouse)

counts_sample_wide2 <- counts_sample[,1:3] %>% 
  pivot_wider(names_from = sample_id, values_from = n)

# Filter counts from counts_sample_wide to test
selected_counts <- counts_sample_wide2 %>%
  filter(cell_type == "other") %>%
  pivot_longer(cols = -cell_type, names_to = "sample_id", values_to = "count")

# Join with meta data to get line_extended information
selected_counts_meta <- left_join(selected_counts, meta, by = c("sample_id" = "sample_id"))

# Box Plot
p <- ggplot(selected_counts_meta, aes(x = mouse, y = `count`)) +
  geom_boxplot(fill = "lightblue", color = "blue") +
  labs(title = "",
       x = "",
       y = "Counts") +
  theme_minimal()
p


# Save summary tables for the delta value
write.table(counts_sample_wide, file.path(result_folder, "counts_sample.txt"), sep = "\t", row.names = FALSE)
write.table(counts_by_line_ext, file.path(result_folder, "counts_by_line_ext.txt"), sep = "\t", row.names = FALSE)
write.table(counts_sample_wide2, file.path(result_folder, "counts_sample2.txt"), sep = "\t", row.names = FALSE)

