library(dplyr)
library(tidyverse)
library(DataExplorer)

data <- read.csv(file = 'store.csv', sep = ';')
data %>%
create_report(
  output_file = "report",
  output_dir = "exports",
  y = "all",
  report_title= "DataExplorer Report"
)
