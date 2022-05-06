library(dplyr)
library(tidyverse)
library(DataExplorer)
print('ola')

setwd("D:/UNIVERSIDADE/4� Ano/2� Semestre/TIAPOSE/TIAPOSE_R_Data_Mining")
data <- read.csv(file = 'store.csv', sep = ';')
data %>%
create_report(
  output_file = "report",
  output_dir = "exports",
  y = "all",
  report_title= "DataExplorer Report"
)


store = read.csv("D:/UNIVERSIDADE/4� Ano/2� Semestre/TIAPOSE/TIAPOSE_R_Data_Mining/data/store.csv")

library(stringr)
week = "1-2-3-4-5-6-7"
weeksplitaux = strsplit(week,"-")
weeksplit = unlist(weeksplitaux[1])
weekvector = as.vector(weeksplit)
