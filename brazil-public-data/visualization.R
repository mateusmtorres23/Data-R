library(tidyverse)
library(sf)
library(ggplot2)
library(leaflet)

load("Data/processed/analytical_results.RData")

brazil_map <- read_rds("Data/processed/brazil-map.rds") 

data <- read_rds("Data/processed/brazil_socioeconomic_education_states_data.rds") %>%
  mutate(ideb_score = as.numeric(ideb_score))

plot_top_ideb <- ggplot(top_5_ideb, aes(x = reorder(name_state, ideb_score), y = ideb_score, fill = name_region)) +
  geom_col() +
  coord_flip() +
  theme_minimal() +
  labs(title = "Top 5 States by IDEB Score", x = "State", y = "IDEB Score")

plot_correlation <- ggplot(data, aes(x = renda_per_capita, y = ideb_score)) +
  geom_point(alpha = 0.6, color = "darkblue") +
  geom_smooth(method = "lm", color = "red", se = FALSE) +
  theme_minimal() +
  labs(title = "Income vs IDEB Correlation", x = "Income Per Capita", y = "IDEB Score")

map_data <- brazil_map %>%
  left_join(data, by = "abbrev_state", suffix = c("", "_numeric")) %>%
  st_transform(crs = 4326)

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









