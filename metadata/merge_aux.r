library(here)
library(tidyverse)

read_dataset <- function(file_name){
  #have to coerce to string if lab_subject_id is read in as int
  read_csv(file_name,  
           col_types = cols(lab_subject_id = "c"))
}

aux_dfs <- lapply(list.files(here("aux_data/by_dataset_aux"), 
                             full.names=T), read_dataset)

full_aux_df <- do.call(bind_rows, 
        aux_dfs)  %>% 
  select(dataset_name, 
         lab_subject_id,
         everything())

full_aux_df %>% 
  write_csv(here("aux_data/aux_data.csv"))
