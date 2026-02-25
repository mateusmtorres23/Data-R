library(sf)
library(geobr)
library(tidyverse)
library(sidrar)
library(ipeadatar)

#geobr data
file_path_map <- "Data/raw/brazil-map.rds"

if (file.exists(file_path_map)) {
  
  brazil_map <- read_rds(file_path_map)
  
} else {
  
  brazil_map <- read_state(showProgress = FALSE, year = 2020)
  write_rds(brazil_map, file_path_map)
  
}

#ipea data
file_path_hdi <- "Data/raw/hdi.rds"

if (file.exists(file_path_hdi)) {
  
  hdi_data <- read_rds(file_path_hdi)
  
} else {
  
  hdi_data <- ipeadata(code = "IDHM")
  write_rds(hdi_data, file_path_hdi)
  
}

#sidra data
file_path_pop <- "Data/raw/population.rds"
file_path_lit <- "Data/raw/literacy.rds"
file_path_inc <- "Data/raw/income.rds"

if (file.exists(file_path_pop)) {
  
  population_data <- read_rds(file_path_pop)
  
} else {
  
  population_data <- get_sidra(x = 4714, geo = "State", period = "2022")
  write_rds(population_data, file_path_pop)
  
}


if (file.exists(file_path_lit)) {
  
  literacy_data <- read_rds(file_path_lit)
  
} else {
  
  literacy_data <- get_sidra(x = 9543, geo = "State", period = "2022", classific = c("c12086" = "all"))
  write_rds(literacy_data, file_path_lit)
  
}
  
  
if (file.exists(file_path_inc)){
  
  income_data <- read_rds(file_path_inc)
  
} else {
  
  income_data <- get_sidra(x = 7531, geo = "State", period = "2023")
  write_rds(income_data, file_path_inc)
  
}

