# 4-multi.R: multi-variate time series multi-step ahead forecasting example.
# this demo works only with the VAR method.

library(vars)
library(fpp2)
library(rminer)

# load the uschange data:
data(uschange) # load uschange data from fpp2
# quarterly data:
print(uschange)
LTS=4 #  1 year, used for the forecasting range
hd=holdout(uschange[,1],ratio=LTS,mode="order") # simple ordered holdout train and test split, rminer function

mtr=uschange[hd$tr,1:2]
mtr=ts(mtr,frequency=4) # TS object, uses forecast library mode!
Y=uschange[hd$ts,1:2]

# p lag order selection for a multi-variate VAR model with 2 time series:
VARselect(mtr,lag.max=8,type="const")[["selection"]]
#> AIC(n)  HQ(n)  SC(n) FPE(n) 
#>      5      1      1      5
#The R output shows the lag length selected by each of the information criteria available in the vars package. There is a large discrepancy between the VAR(5) selected by the AIC and the VAR(1) selected by the BIC. This is not unusual. As a result we first fit a VAR(1), as selected by the BIC.
var1=VAR(mtr,p=1,type="const")
serial.test(var1,lags.pt=10,type="PT.asymptotic")
var2=VAR(mtr,p=2, type="const")
serial.test(var2,lags.pt=10,type="PT.asymptotic")
var3=VAR(mtr,p=3,type="const")
serial.test(var3, lags.pt=10, type="PT.asymptotic")
#>  Portmanteau Test (asymptotic)
#In similar fashion to the univariate ARIMA methodology, we test that the residuals are uncorrelated using a Portmanteau test25. Both a VAR(1) and a VAR(2) have some residual serial correlation, and therefore we fit a VAR(3).
#>  Portmanteau Test (asymptotic)
#> data:  Residuals of VAR object var3
#> Chi-squared = 33.463, df = 28, p-value = 0.2191
#The residuals for this model pass the test for serial correlation.
F1=forecast(var3,h=LTS) # similar to the forecast library function, multi-step ahead forecasts
Pred1=as.numeric(F1$forecast$Consumption$mean)
Pred2=as.numeric(F1$forecast$Income$mean)

main=paste("Consumption (MAE=",round(mmetric(Y[,1],Pred1,metric="MAE"),3),")",sep="")
mgraph(Y[,1],Pred1,main=main,graph="REG",Grid=10,col=c("black","blue"),leg=list(pos="topleft",leg=c("target","VAR pred.")))
mpause()

main=paste("Income (MAE=",round(mmetric(Y[,2],Pred2,metric="MAE"),3),")",sep="")
mgraph(Y[,2],Pred2,main=main,graph="REG",Grid=10,col=c("black","blue"),leg=list(pos="topleft",leg=c("target","VAR pred.")))

