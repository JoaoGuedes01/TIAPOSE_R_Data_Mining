#library imports
library(tidyverse)
library(fpp2)

data <- read.csv(file = '../data/store.csv', sep = ';')

data %>%
  mutate(date=as.Date(date, format = "%Y.%m.%d"))
data$date
visits <- ts(data$all, frequency=5)
visits
autoplot(visits)

# Additive decomposition
decomposed_visits_add <- decompose(visits, type="additive")
autoplot(decomposed_visits_add)

# Multiplicative decomposition
decomposed_visits_add <- decompose(visits, type="additive")
autoplot(decomposed_visits_add)

# Forecasting Exponential Smoothing
autoplot(ses(visits), PI = FALSE)

# Forecasting Holt's method
autoplot(holt(visits), PI = FALSE)

# Forecasting Damped Holt's method
autoplot(holt(visits, damped = TRUE, h = 36), PI = FALSE)

# Forecasting ETS method
autoplot(forecast(ets(visits), h = 12, PI=FALSE))

