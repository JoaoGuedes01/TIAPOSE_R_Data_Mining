# 1-sunspots.R: univariate time series forecasting example that considers only 1-step ahead forecasts.
library(rminer) # by Paulo Cortez@

# read the time series into object S
S=read.table("sunspots.ts",header=TRUE,sep=";")[,1]
NPRED=10 # number of predictions
srange=diff(range(S)) # compute the range of S

# show S and some statistics:
print(S)
print(summary(S))
cat("range:",srange,"\n")
cat("size:",length(S),"\n")
plot(S,type="l",col="blue")
acf(S) # autocorrelation plot

# CasesSeries: convert a single time series into a data.frame with inputs (...,lag2,lag1) and target output (y)
# selection of all 1 to 11 time lags:
D=CasesSeries(S,c(1:11)) # 11 time lags t-1,t-2,t-3,t-4,t-5,t-6,t-7,t-8,t-9,t-10,t-11 -> t
print(summary(D))
print("Show TR and TS indexes:")
N=nrow(D) # number of D examples
NTR=N-NPRED
TR=1:NTR # training row elements of D (oldest elements), excluding last NPRED rows
TS=(NTR+1):N #  test row elements of D (more recent elements), total of NPRED rows
print("TR:")
print(TR)
print("TS:")
print(TS)

# fit a Neural Network (NN) - multilayer perceptron ensemble with training data: 
NN=fit(y~.,D[TR,],model="mlpe",search="heuristic")
# fit a randomForest: 
RF=fit(y~.,D[TR,],model="randomForest",search="heuristic")

# 1-ahead predictions:
print("Predictions (1-ahead):")
PNN=predict(NN,D[TS,])
PRF=predict(RF,D[TS,])

# store the output target into object Y
Y=D[TS,]$y # real observed values

# show forecasting measures and graph:
cat("NN (MLP) predictions:\n")
print(PNN)
cat("MAE:",mmetric(Y,PNN,metric="MAE"),"\n")
cat("NMAE:",mmetric(Y,PNN,metric="NMAE",val=srange),"\n")
cat("RMSE:",mmetric(Y,PNN,metric="RMSE"),"\n")
cat("RRSE:",mmetric(Y,PNN,metric="RRSE"),"\n")

cat("RF predictions:\n")
print(PRF)
cat("MAE:",mmetric(Y,PRF,metric="MAE"),"\n")
cat("NMAE:",mmetric(Y,PRF,metric="NMAE",val=srange),"\n")
cat("RMSE:",mmetric(Y,PRF,metric="RMSE"),"\n")
cat("RRSE:",mmetric(Y,PRF,metric="RRSE"),"\n")

# graph: REC - simple Regression Plot
print("Graph with NN predictions (1-ahead):")
mgraph(Y,PNN,graph="REG",Grid=10,lty=1,col=c("black","blue"),main="NN predictions",leg=list(pos="topright",leg=c("target","predictions")))
