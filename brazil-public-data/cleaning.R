library(tidyverse)
library(janitor)
library(readxl)
library(stringi)
library(sf)

#file paths
path_raw_map <- "Data/raw/brazil-map.rds"

path_raw_pop <- "Data/raw/population.rds"
path_raw_lit <- "Data/raw/literacy.rds"
path_raw_inc <- "Data/raw/income.rds"

path_raw_states_IDEB <- "Data/raw/states_IDEB_2023.xlsx"
path_raw_muni_ef_IDEB <- "Data/raw/muni_ef_IDEB_2023.xlsx"
path_raw_muni_em_IDEB <- "Data/raw/muni_em_IDEB_2023.xlsx"

#cleaning IDEB data

raw_pop_data <- read_rds(path_raw_pop)
raw_lit_data <- read_rds(path_raw_lit)
raw_inc_data <- read_rds(path_raw_inc)

raw_ideb_states_data <- read_excel(path_raw_states_IDEB, skip = 9) %>%
  clean_names() %>%
  rename(unidade_federacao = x1, rede = x2)

raw_ideb_muni_ef_data <- read_excel(path_raw_muni_ef_IDEB, skip = 9) %>%
  clean_names() %>%
  mutate(cycle = "fundamental")
raw_ideb_muni_em_data <- read_excel(path_raw_muni_em_IDEB, skip = 9) %>%
  clean_names() %>%
  mutate(cycle = "ensino_medio")
  
ideb_muni_data <- bind_rows(raw_ideb_muni_ef_data, raw_ideb_muni_em_data)

write_rds(ideb_muni_data, "Data/processed/ideb_municipalities.rds")

# cleaning data to add the IBGE state codes to the IDEB data

brazil_map <- read_rds(path_raw_map)

brazil_state_info <- brazil_map %>% 
  st_drop_geometry() %>%
  mutate(
    name_state_norm = str_to_upper(name_state),
    name_state_norm = stri_trans_general(name_state_norm, "Latin-ASCII"),
    name_state_norm = str_squish(name_state_norm)
  )

ideb_states_data_norm <- raw_ideb_states_data %>%
  mutate(
    unidade_federacao = str_squish(unidade_federacao),
    unidade_federacao = case_match(
      unidade_federacao,
      "R. G. do Norte" ~ "Rio Grande do Norte",
      "R. G. do Sul" ~ "Rio Grande do Sul",
      "M. G. do Sul" ~ "Mato Grosso do Sul",
      .default = unidade_federacao
    ),
    uf_norm = str_to_upper(unidade_federacao),
    uf_norm = stri_trans_general(uf_norm, "Latin-ASCII")
  )

ideb_states_data <- inner_join(
  ideb_states_data_norm, 
  brazil_state_info, 
  by = c("uf_norm" = "name_state_norm")
) %>%
  select(-uf_norm)









