library(plumber)

pr <- plumb("serverFunctions.R")

pr$run(port=8000)

# 1_2_3_4_5_6_7
