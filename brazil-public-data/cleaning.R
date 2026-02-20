library(tidyverse)
library(janitor)
library(readxl)

#file paths
path_raw_map <- "Data/raw/brazil-map.rds"

path_raw_pop <- "Data/raw/population.rds"
path_raw_lit <- "Data/raw/literacy.rds"
path_raw_inc <- "Data/raw/income.rds"

path_raw_states_IDEB <- "Data/raw/states_IDEB_2023.xlsx"
path_raw_muni_ef_IDEB <- "Data/raw/muni_ef_IDEB_2023.xlsx"
path_raw_muni_em_IDEB <- "Data/raw/muni_em_IDEB_2023.xlsx"

#cleaning IDEB data
raw_map_data <- read_rds(path_raw_map)

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

# adding the IBGE state codes to the IDEB data

brazil_map <- read_rds("Data/raw/brazil-map.rds")

brazil_state_info <- brazil_map %>% st_drop_geometry()

raw_ideb_states_data <- raw_ideb_states_data %>%
  mutate(
    unidade_federacao = str_squish(unidade_federacao),
    unidade_federacao = case_match(
      unidade_federacao,
      "R. G. do Norte" ~ "Rio Grande do Norte",
      "R. G. do Sul" ~ "Rio Grande do Sul",
      "M. G. do Sul" ~ "Mato Grosso do Sul",
      .default = unidade_federacao
    )
  )

raw_ideb_states_data <- left_join(
  raw_ideb_states_data, 
  brazil_state_info, 
  by = c("unidade_federacao" = "name_state")
)

null_data <- raw_ideb_states_data %>%
  filter(is.na(code_state)) %>%
  select(unidade_federacao, rede)

print(null_data, n = 55)












