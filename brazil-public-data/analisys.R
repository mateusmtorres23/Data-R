library(tidyverse)

data <- read_rds("Data/processed/brazil_socioeconomic_education_states_data.rds") 

data <- data %>%
  mutate(ideb_score = as.numeric(ideb_score))

regional_summary <- data %>%
  group_by(name_region) %>%
  summarise(across(
    .cols = c(ideb_score, renda_per_capita, idh_score, taxa_alfabetizacao), 
    .fns = list(
      mean = ~mean(.x, na.rm = TRUE),
      median = ~median(.x, na.rm = TRUE),
      sd = ~sd(.x, na.rm = TRUE)
    ),
    .names = "{.col}_{.fn}"
  )) %>%
  arrange(desc(ideb_score_mean))

correlation_matrix <- data %>%
  select(where(is.numeric)) %>%
  cor(use = "complete.obs", method = "pearson") %>%
  round(2)

top_5_ideb <- data %>%
  arrange(desc(ideb_score)) %>%
  slice_head(n = 5) %>%
  select(name_state, name_region, ideb_score)

bottom_5_ideb <- data %>%
  arrange(ideb_score) %>%
  slice_head(n = 5) %>%
  select(name_state, name_region, ideb_score)

top_5_literacy <- data %>%
  arrange(desc(taxa_alfabetizacao)) %>%
  slice_head(n = 5) %>%
  select(name_state, name_region, taxa_alfabetizacao)

bottom_5_literacy <- data %>%
  arrange(taxa_alfabetizacao) %>%
  slice_head(n = 5) %>%
  select(name_state, name_region, taxa_alfabetizacao)

save(
  regional_summary, 
  correlation_matrix, 
  top_5_ideb, 
  bottom_5_ideb, 
  top_5_literacy, 
  bottom_5_literacy, 
  file = "Data/processed/analytical_results.RData"
)







