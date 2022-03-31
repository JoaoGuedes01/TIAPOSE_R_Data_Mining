# Script demonstration of growing window and rolling window evaluations.

library(forecast) # access forecast functions -> HoltWinters, forecast
library(rminer) # access rminer functions -> CasesSeries, fit, lforecast, mmetric, mgraph, ...

# setwd() # adjust working directory if needed.

# read data:
cat("read passenger time series:")
d1=read.table("passengers.ts",header=TRUE,sep=";")
d1=d1[,1] # vector of numeric
L=length(d1) # size of the time series, 144
K=12 # assumption for the seasonal period: test also acf(d1S)

print("incremental (growing) window training demonstration:")

Test=K # H, the number of multi-ahead steps, adjust if needed
S=round(K/3) # step jump: set in this case to 4 months, a quarter
Runs=8 # number of growing window iterations, adjust if needed

# forecast:
W=(L-Test)-(Runs-1)*S # initial training window size for the ts space (forecast methods)

# rminer:
timelags=c(1,12,13) # 1 previous month, 12 and 13 previous year months, you can test other combinations, such as 1:13
D=CasesSeries(d1,timelags) # note: nrow(D) is smaller by max timelags than length(d1)
W2=W-max(timelags) # initial training window size for the D space (CasesSeries, rminer methods)

YR=diff(range(d1)) # global Y range, use the same range for the NMAE calculation in all iterations

ev=vector(length=Runs) # error vector for "HoltWinters"
ev2=vector(length=Runs) # error vector for "mlpe"

# growing window:
for(b in 1:Runs)  # cycle of the incremental window training (growing window)
{
  # code for the forecast package methods, HoltWinters is just an example:
  H=holdout(d1,ratio=Test,mode="incremental",iter=b,window=W,increment=S)   
  trinit=H$tr[1]
  dtr=ts(d1[H$tr],frequency=K) # create ts object, note that there is no start argument (for simplicity of the code)
  M=suppressWarnings(HoltWinters(dtr)) # create forecasting model, suppressWarnings removes warnings from HW method
  Pred=forecast(M,h=length(H$ts))$mean[1:Test] # multi-step ahead forecasts
  ev[b]=mmetric(y=d1[H$ts],x=Pred,metric="NMAE",val=YR)

  # code for rminer package methods, "mlpe" is just an example:
  H2=holdout(D$y,ratio=Test,mode="incremental",iter=b,window=W2,increment=S)   
     # note: the last training value is the same for dtr, namely:
     # print(dtr[length(dtr)])  
     # print(D[H2$tr[length(H2$tr)],]) # y is equal to previously shown value  
  M2=fit(y~.,D[H2$tr,],model="mlpe") # create forecasting model
  Pred2=lforecast(M2,D,start=(length(H2$tr)+1),Test) # multi-step ahead forecasts
  ev2[b]=mmetric(y=d1[H$ts],x=Pred2,metric="NMAE",val=YR)

  cat("iter:",b,"TR from:",trinit,"to:",(trinit+length(H$tr)-1),"size:",length(H$tr),
      "TS from:",H$ts[1],"to:",H$ts[length(H$ts)],"size:",length(H$ts),
      "nmae:",ev[b],",",ev2[b],"\n")
} # end of cycle

# show median of ev and ev2
cat("median NMAE values for HW and mlpe:\n")
cat("Holt-Winters median NMAE:",median(ev),"\n")
cat("mlpe median NMAE:",median(ev2),"\n")

mgraph(d1[H$ts],Pred,graph="REG",Grid=10,col=c("black","blue","red"),leg=list(pos="topleft",leg=c("target","HW pred.","mlpe")))
lines(Pred2,pch=19,cex=0.5,type="b",col="red")

mpause() # wait for enter

# rolling window:
for(b in 1:Runs)  # cycle of the incremental window training (growing window)
{
  # code for the forecast package methods, HoltWinters is just an example:
  H=holdout(d1,ratio=Test,mode="rolling",iter=b,window=W,increment=S)   
  trinit=H$tr[1]
  dtr=ts(d1[H$tr],frequency=K) # create ts object, note that there is no start argument (for simplicity of the code)
  M=suppressWarnings(HoltWinters(dtr)) # create forecasting model, suppressWarnings removes warnings from HW method
  Pred=forecast(M,h=length(H$ts))$mean[1:Test] # multi-step ahead forecasts
  ev[b]=mmetric(y=d1[H$ts],x=Pred,metric="NMAE",val=YR)

  # code for rminer package methods, "mlpe" is just an example:
  H2=holdout(D$y,ratio=Test,mode="incremental",iter=b,window=W2,increment=S)   
     # note: the last training value is the same for dtr, namely:
     # print(dtr[length(dtr)])  
     # print(D[H2$tr[length(H2$tr)],]) # y is equal to previously shown value  
  M2=fit(y~.,D[H2$tr,],model="mlpe") # create forecasting model
  Pred2=lforecast(M2,D,start=(length(H2$tr)+1),Test) # multi-step ahead forecasts
  ev2[b]=mmetric(y=d1[H$ts],x=Pred2,metric="NMAE",val=YR)

  cat("iter:",b,"TR from:",trinit,"to:",(trinit+length(H$tr)-1),"size:",length(H$tr),
      "TS from:",H$ts[1],"to:",H$ts[length(H$ts)],"size:",length(H$ts),
      "nmae:",ev[b],",",ev2[b],"\n")
} # end of cycle

# show median of ev and ev2
cat("median NMAE values for HW and mlpe:\n")
cat("Holt-Winters median NMAE:",median(ev),"\n")
cat("mlpe median NMAE:",median(ev2),"\n")

# last iteration predictions:
mgraph(d1[H$ts],Pred,graph="REG",Grid=10,col=c("black","blue","red"),leg=list(pos="topleft",leg=c("target","HW pred.","mlpe")))
lines(Pred2,pch=19,cex=0.5,type="b",col="red")
