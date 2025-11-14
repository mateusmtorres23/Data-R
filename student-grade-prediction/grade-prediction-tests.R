library(tidyverse)
library(tidymodels)

# Data cleaning and merging

d1 <- read_delim("Data/student-mat.csv", delim = ";")
d2 <- read_delim("Data/student-por.csv", delim = ";")
glimpse(d1)
glimpse(d2)

merge_keys <- c("school", "sex", "age", "address", "famsize", "Pstatus", 
                "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery", "internet")

d3 <- inner_join(d1, d2, by = merge_keys, relationship = "many-to-many")

print(paste("Total merged students: ", nrow(d3)))

d3_clean <- d3 %>%
  rename_with(~str_replace(., "\\.x$", "_mat"), ends_with(".x")) %>%
  rename_with(~str_replace(., "\\.y$", "_por"), ends_with(".y"))
glimpse(d3_clean)

# preparing data for training

set.seed(123)

math_split <- initial_split(d3_clean, prop = 0.80, strata = G3_mat)
math_train <- training(math_split)
math_test <- testing(math_split)


print(paste("math split - train/test", nrow(math_train), "/", nrow(math_test)))  

por_split <- initial_split(d3_clean, prop = 0.80, strata = G3_por)
por_train <- training(por_split)
por_test <- testing(por_split)

print(paste("portugues split - test/train", nrow(por_train), "/", nrow(por_test)))


# Training the models

math_lm_recipe <- recipe(G3_mat ~., data = math_train)%>%
  step_rm(ends_with("_por")) %>%
  step_dummy(all_nominal_predictors()) %>%
  step_normalize(all_numeric_predictors())
print(math_lm_recipe)

math_rf_recipe <- recipe(G3_mat ~ ., data = math_train) %>%
  step_rm(ends_with("_por"))

port_lm_recipe <- recipe(G3_por ~., data = por_train) %>%
  step_rm(ends_with("_mat")) %>%
  step_dummy(all_nominal_predictors()) %>%
  step_normalize(all_numeric_predictors()) %>%
print(port_lm_recipe)

port_rf_recipe <- recipe(G3_por ~ ., data = por_train) %>%
  step_rm(ends_with("_mat"))

lr_spec <- linear_reg() %>% set_engine("lm")

rf_spec <- rand_forest() %>%
  set_engine("ranger", importance = "permutation") %>%
  set_mode("regression")

# math models

math_flow_lr <- workflow() %>%
  add_recipe(math_lm_recipe) %>%
  add_model(lr_spec)

math_flow_rf <- workflow() %>%
  add_recipe(math_rf_recipe) %>%
  add_model(rf_spec)

# portuguese models

port_flow_lr <- workflow() %>%
  add_recipe(port_lm_recipe) %>%
  add_model(lr_spec)

port_flow_rf <- workflow() %>%
  add_recipe(port_rf_recipe) %>%
  add_model(rf_spec)

# training and testing math LR model
math_fit_lr <- fit(math_flow_lr, data = math_train)

print(math_fit_lr)

math_results_lr <- predict(math_fit_lr, math_test) %>%
  bind_cols(math_test)

math_metrics_lr <- math_results_lr %>%
  metrics(truth = G3_mat, estimate = .pred)

print(math_metrics_lr)

# training and testing RF math model
math_fit_rf <- fit(math_flow_rf, data = math_train)

print(math_fit_rf)

math_results_rf <- predict(math_fit_rf, math_test) %>%
  bind_cols(math_test)

math_metrics_rf <- math_results_rf %>%
  metrics(truth = G3_mat, estimate = .pred)
print(math_metrics_rf)

# training and testing portuguese LR model
port_fit_lr <- fit(port_flow_lr, data = por_train)

print(port_fit_lr)

port_results_lr <- predict(port_fit_lr, por_test) %>%
  bind_cols(por_test)

port_metrics_lr <- port_results_lr %>%
  metrics(truth = G3_por, estimate = .pred)

print(port_metrics_lr)

# training and testing RF portuguese model
port_fit_rf <- fit(port_flow_rf, data = por_train)

print(port_fit_rf)

port_results_rf <- predict(port_fit_rf, por_test) %>%
  bind_cols(por_test)

port_metrics_rf <- port_results_rf %>%
  metrics(truth = G3_por, estimate = .pred)

print(port_metrics_rf)

# Final comparison
print(math_metrics_lr)

print(math_metrics_rf)

print(port_metrics_lr)

print(port_metrics_rf)

# Model interpretation and plotting

math_lr_coeffs <- math_fit_lr %>%
  extract_fit_parsnip() %>%
  tidy()

top_lr_coeffs <- math_lr_coeffs %>%
  filter(term != "(Intercept)") %>%
  mutate(abs_estimate = abs(estimate)) %>%
  slice_max(n = 15, order_by = abs_estimate)

print(top_lr_coeffs)

plot_lr_coeffs <- ggplot(top_lr_coeffs, aes(x = estimate, y = fct_reorder(term, estimate), fill = estimate > 0)) +
  geom_col(show.legend =  FALSE) +
  labs(
    title = "Top 15 predictors of math performance",
    subtitle = "Coefficients from linear regression model",
    x = "Coefficient estimate (Impact on G3_mat)",
    Y = "Predictor term"
  ) +
  theme_minimal() +
  scale_fill_manual(values = c(`TRUE` = "#0072b2", `FALSE` = "#D55E00"))
print(plot_lr_coeffs)




















