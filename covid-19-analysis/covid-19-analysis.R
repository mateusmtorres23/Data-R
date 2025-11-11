library(tidyverse)
library(ggplot2)
library(lubridate)

# Manipulating the data

covid_data <- read_csv("Data/covid_19_dataset.csv")

brazil_data <- covid_data |> filter(country == "Brazil")
print(brazil_data)
glimpse(brazil_data)

brazil_data_clean <- brazil_data |> select(date, total_cases, total_deaths, people_vaccinated)
print(brazil_data_clean)

# building cases graphs

cases_plot <- ggplot(brazil_data_clean, aes(x = date, y = total_cases)) + 
  geom_line(color = "blue", linewidth = 1) +
  labs(
    title = "Growth of cases of COVID-19 cases by week in Brazil",
    x = "Date",
    y = "Cases growth"
  ) +
  theme_minimal() +
  scale_y_continuous(labels = scales::label_number())


weekly_cases_data <- brazil_data_clean |>
  arrange(date) |>
  mutate(
    new_cases = total_cases - lag(total_cases, default=0)
  ) |>
  mutate(
    week_start = floor_date(date, unit = "week", week_start = 1)
  ) |>
  group_by(week_start) |>
  summarise(
    total_weekly_cases = sum(new_cases, na.rm=TRUE)
  )

print(weekly_cases_data)


weekly_cases_plot <- ggplot(weekly_cases_data, aes(x = week_start, y = total_weekly_cases)) +
  geom_col(fill = "steelblue") +
  labs(
    title = "Total weekly COVID-19 cases in Brazil",
    x = "Week",
    y = "Total weekly cases"
  ) +
  theme_minimal() +
  scale_y_continuous(labels = scales::label_number())

# Building death plots

death_plots <- ggplot(brazil_data_clean, aes(x = date, y = total_deaths)) +
  geom_line(color = "red", linewidth = 1) +
  labs(
    title = "Growth of deaths by COVID-19 cases by week in Brazil",
    x = "Date",
    y = "Death growths"
  ) +
  theme_minimal() +
  scale_y_continuous(labels = scales::label_number())

weekly_death_data <- brazil_data_clean |>
  arrange(date) |>
  mutate(
    new_deaths = total_deaths - lag(total_deaths, default = 0)
  ) |>
  mutate(
    week_start = floor_date(date, unit = 'week', week_start = 1)
  ) |>
  group_by(week_start) |>
  summarise(
    total_weekly_deaths = sum(new_deaths, na.rm = TRUE)
  )

weekly_death_plot <- ggplot(weekly_death_data, aes(x = week_start, y = total_weekly_deaths)) +
  geom_col(fill = 'darkred') +
  labs(
    title = 'Total weekly COVID-19 deaths in Brazil',
    x = 'Week',
    y = 'Total weekly deaths'
  )+
  theme_minimal() +
  scale_y_continuous(labels = scales::label_number())

# Building vaccination plots

vaccination_plot <- ggplot(brazil_data_clean, aes(x = date, y = people_vaccinated)) +
  geom_line(color = 'green', linewidth = 1) +
  labs(
    title = "Growth of people vaccinated for COVID-19 in Brazil",
    x = 'Date',
    y = 'Vaccination growth'
  ) +
  theme_minimal() +
  scale_y_continuous(labels = scales::label_number())

weekly_vacc_data <- brazil_data_clean |>
  arrange(date) |>
  mutate(
    new_vaccs = people_vaccinated - lag(people_vaccinated, default = 0)
  )|>
  mutate(
    week_start = floor_date(date, unit = 'week', week_start = 1)
  ) |>
  group_by(week_start) |>
  summarise(
    total_weekly_vaccs = sum(new_vaccs, na.rm = TRUE)
  )

weekly_vaccs_plot <- ggplot(weekly_vacc_data, aes(x = week_start, y = total_weekly_vaccs)) +
  geom_col(fill = 'forestgreen') +
  labs(
    title = 'Total weekly COVID-19 vaccinations in Brazil',
    x = 'Week',
    y = 'Total weekly vaccinations'
  ) +
  theme_minimal() +
  scale_y_continuous(labels = scales::label_number())  

# Printing the plots

print(cases_plot)
print(weekly_cases_plot)
print(death_plots)
print(weekly_death_plot)
print(vaccination_plot)
print(weekly_vaccs_plot)
