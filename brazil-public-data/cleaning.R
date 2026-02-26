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
file_path_hdi <- "Data/raw/hdi.rds"

path_raw_states_IDEB <- "Data/raw/states_IDEB_2023.xlsx"

# cleaning data to add the IBGE state codes to the IDEB data

raw_ideb_states_data <- read_excel(path_raw_states_IDEB, skip = 9) %>%
  clean_names() %>%
  rename(unidade_federacao = x1, rede = x2)

brazil_map <- read_rds(path_raw_map)

brazil_state_info <- brazil_map %>% 
  st_drop_geometry() %>%
  mutate(
    name_state_norm = str_to_upper(name_state),
    name_state_norm = stri_trans_general(name_state_norm, "Latin-ASCII"),
    name_state_norm = str_squish(name_state_norm)
  )

ideb_states_data_norm <- raw_ideb_states_data %>%
  filter(str_detect(rede, "Pública")) %>%
  mutate(
    rede = str_remove(rede, "\\s*\\(.*\\)"),
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
  select(
    code_state,
    name_state,
    abbrev_state,
    name_region,
    ideb_score = vl_observado_2023
  ) %>%
  mutate(code_state = as.character(code_state))
  

#cleaning hdi data

hdi_data <- read_rds(file_path_hdi)

states_hdi_data <- semi_join(
  hdi_data,
  brazil_map,
  by = join_by(tcode == code_state)
  ) %>%
  filter(date == max(date)) %>%
  rename(code_state = tcode, idh_score = value) %>%
  mutate(code_state = as.character(code_state)) %>%
  select(-code, -date, -uname)

#cleaning IBGE data
raw_pop_data <- read_rds(path_raw_pop)
raw_lit_data <- read_rds(path_raw_lit)
raw_inc_data <- read_rds(path_raw_inc)

lit_data <- raw_lit_data %>%
  filter(
    Sexo == "Total",
    `Cor ou raça` == "Total",
    Idade == "Total"
  ) %>%
  select(
    code_state = `Unidade da Federação (Código)`,
    taxa_alfabetizacao = Valor
  ) %>%
  mutate(code_state = as.character(code_state))
  
inc_data <- raw_inc_data %>%
  filter(
    `Classes de percentual das pessoas em ordem crescente de rendimento domiciliar per capita` == "Total",
    !str_detect(Variável, "Coeficiente de variação")
  ) %>%
  select(
    code_state = `Unidade da Federação (Código)`,
    renda_per_capita = Valor
  ) %>%
  mutate(code_state = as.character(code_state))
  
pop_data <- raw_pop_data %>%
  filter(
    Variável == "População residente"
  ) %>%
  select(
    code_state = `Unidade da Federação (Código)`,
    populacao = Valor
  ) %>%
  mutate(code_state = as.character(code_state))

brazil_socioeconomic_education_states_data <- ideb_states_data %>%
  left_join(states_hdi_data, by = "code_state") %>%
  left_join(lit_data, by = "code_state") %>%
  left_join(inc_data, by = "code_state") %>%
  left_join(pop_data, by = "code_state")

write_rds(brazil_socioeconomic_education_states_data, "Data/processed/brazil_socioeconomic_education_states_data.rds")



