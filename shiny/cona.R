# Importar Libraries
library(tidyverse)
library(rminer)
library(forecast)

# Importar os dados
data <- read.csv(file = './cenarios/Cenario 1/TS1.csv')

# Retirar a coluna X (Index)
data = data %>% select(-X)



data = ts1
chosen = c(36:42)
cona = data[36:42,]
data = data[- chosen,]
test = rbind(data,cona)
row.names(test) <- NULL
d1 = test[,1] # coluna target
L = length(d1)
K=7
Test = K

timelags = c(1:7)
D = CasesSeries(d1,timelags)

H=holdout(test[,1],ratio=7,mode="order")

M = fit(y~.,D[H$tr,],model="lm")
Pred = lforecast(M,D,start=(length(H$tr)+1),Test)
print('Preds:')
print(Pred)
ev=mmetric(y=d1[H$ts],x=Pred,metric="MAE",val=YR)
