library(tidyverse)
library(sf)
library(ggplot2)
library(leaflet)
library(plotly)

load("Data/processed/analytical_results.RData")

brazil_map <- read_rds("Data/processed/brazil-map.rds") 

data <- read_rds("Data/processed/brazil_socioeconomic_education_states_data.rds") %>%
  mutate(ideb_score = as.numeric(ideb_score))

plot_top_ideb <- ggplot(top_5_ideb, aes(x = reorder(name_state, ideb_score), y = ideb_score, fill = name_region)) +
  geom_col() +
  coord_flip() +
  theme_minimal() +
  labs(title = "Top 5 States by IDEB Score", x = "State", y = "IDEB Score")

plot_correlation <- ggplot(data, aes(x = renda_per_capita, y = ideb_score, text = paste("Estado:", name_state))) + # Adicionei 'text' aqui
  geom_point(alpha = 0.6, color = "darkblue") +
  geom_smooth(method = "lm", color = "red", se = FALSE) +
  theme_minimal() +
  labs(title = "Income vs IDEB Correlation", x = "Income Per Capita", y = "IDEB Score")

map_data <- brazil_map %>%
  left_join(data, by = "abbrev_state", suffix = c("", "_numeric")) %>%
  st_transform(crs = 4326)

ideb_palette <- colorNumeric(palette = "YlGnBu", domain = map_data$ideb_score)

interactive_map <- leaflet(map_data) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addPolygons(
    fillColor = ~ideb_palette(ideb_score),
    weight = 1,
    opacity = 1,
    color = "white",
    fillOpacity = 0.8,
    label = ~paste0(name_state, ": ", ideb_score)
  ) %>%
  addLegend(pal = ideb_palette, values = ~ideb_score, title = "IDEB", position = "bottomright")

interactive_correlation <- ggplotly(plot_correlation, tooltip = c("x", "y", "text"))

plot_boxplot_region <- ggplot(data, aes(x = name_region, y = ideb_score, fill = name_region)) +
  geom_boxplot(alpha = 0.7, outlier.colour = "red") +
  labs(title = "Dispersão do IDEB por Região", x = "Região", y = "Score IDEB") +
  theme_minimal() +
  theme(legend.position = "none")

plot_map_literacy <- ggplot(map_data) +
  geom_sf(aes(fill = taxa_alfabetizacao), color = "white", size = 0.1) +
  scale_fill_viridis_c(option = "magma", direction = -1, name = "Alfabetização (%)") +
  labs(title = "Taxa de Alfabetização por Estado") +
  theme_void()

plot_map_income <- ggplot(map_data) +
  geom_sf(aes(fill = renda_per_capita), color = "white", size = 0.1) +
  scale_fill_distiller(palette = "Greens", direction = 1, name = "Renda (R$)") +
  labs(title = "Renda Domiciliar Per Capita") +
  theme_void()




