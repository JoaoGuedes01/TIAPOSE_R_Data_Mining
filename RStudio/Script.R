library(dplyr)
library(tidyverse)
library(DataExplorer)
library(skimr)

data <- read.csv(file = 'data/store.csv', sep = ';')




# Criar Relatório EDA em HTML
data %>%
create_report(
  output_file = "report",
  output_dir = "exports",
  y = "all",
  report_title= "DataExplorer Report"
)
