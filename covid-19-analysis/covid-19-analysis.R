library(tidyverse)
library(zoo)
library(ggplot2)
library(lubridate)

# Manipulating the data

covid_data <- read_csv("Data/covid_19_dataset.csv")

brazil_data <- covid_data |> filter(country == "Brazil")
print(brazil_data)
glimpse(brazil_data)

brazil_data_clean <- brazil_data |> select(date, total_cases, total_deaths, people_vaccinated)
print(brazil_data_clean)


brazil_data_calculated <- brazil_data_clean |> 
  arrange(date) |>
  mutate(
    newcases_7days_avg = rollmean(total_cases, k=7, fill=NA, align="right"),
    newdeaths_7days_avg = rollmean(total_deaths, k=7, fill=NA, align="right")
  )

print(brazil_data_calculated)
glimpse(brazil_data_calculated)

# Plotting cases graphs

cases_plot <- ggplot(brazil_data_calculated, aes(x = date, y = newcases_7days_avg)) + 
  geom_line(color = "blue", linewidth = 1) +
  labs(
    title = "Moving avarage of cases of COVID-19 cases by week in Brazil",
    x = "Date",
    y = "Avarage daily cases"
  ) +
  theme_minimal() +
  scale_y_continuous(labels = scales::label_number())

print(cases_plot)


weekly_data <- brazil_data_clean |>
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

print(weekly_data)


weekly_plot <- ggplot(weekly_data, aes(x = week_start, y = total_weekly_cases)) +
  geom_col(fill = "steelblue") +
  labs(
    title = "Total weekly COVID-19 cases in Brazil",
    x = "Week",
    y = "Total weekly cases"
  ) +
  theme_minimal() +
  scale_y_continuous(labels = scales::label_number())

print(weekly_plot)

# Plotting Deaths graphs

death_plots <- ggplot(brazil_data_calculated, aes(x = date, y = newdeaths_7days_avg)) +
  geom_line(color = "red", linewidth = 1) +
  labs(
    title = "Moving avarage of death oby COVID-19 cases by week in Brazil",
    x = "date",
    y = "Avarage daily deaths"
  ) +
  theme_minimal() +
  scale_y_continuous(labels = scales::label_number())

print(death_plots)














