library(dplyr)
library(tidyverse)
library(DataExplorer)

setwd("D:/UNIVERSIDADE/4º Ano/2º Semestre/TIAPOSE/TIAPOSE_R_Data_Mining")
data <- read.csv(file = 'store.csv', sep = ';')
data %>%
create_report(
  output_file = "report",
  output_dir = "exports",
  y = "all",
  report_title= "DataExplorer Report"
)


store = read.csv("D:/UNIVERSIDADE/4º Ano/2º Semestre/TIAPOSE/TIAPOSE_R_Data_Mining/data/store.csv")