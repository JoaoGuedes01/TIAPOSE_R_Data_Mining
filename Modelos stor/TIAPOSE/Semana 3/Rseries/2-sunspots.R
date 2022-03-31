# 2-sunspots.R: univariate time series forecasting example that considers only 1-step ahead forecasts.
#               this demo compares 3 Neural Network architectures: 2 MLP and 1 Elman.
#               there are 2 input variants for MLP and Elman:
#               feedforward model (needs several input lags):
#               NN - 11 input time lags (11 inputs)
#               NN1 - 1 input time lag y_(t-1), produces worst results
#               recurrent model (needs only 1 input lag):
#               EL
library(rminer) # by Paulo Cortez@2021

library(RSNNS) # library with several Neural Network (NN) models, including Elman

S=read.table("sunspots.ts",header=TRUE,sep=";")[,1]
NPRED=10 # number of predictions
srange=diff(range(S))

# lets scale the data to [0,1] range, using MAX=250 and MIN=0
MAX=250;MIN=0;RANGE=(MAX-MIN)
SS=(S-MIN)/RANGE
# S is a time series. Create train and test data:
H=holdout(S,ratio=NPRED,mode="order") # time ordered holdout split

# train:
lags=11
DS=CasesSeries(SS,c(1:lags)) # 11 time lags t-1,t-2,t-3,t-4,t-5,t-6,t-7,t-8,t-9,t-10,t-11 -> t
print(summary(DS))
print("Show TR and TS indexes:")
N=nrow(DS) # number of D examples
NTR=N-NPRED
TR=1:NTR # training row elements of D, excluding last NPRED rows
TS=(NTR+1):N #  test row elements of D, total of NPRED rows
print("TR:")
print(TR)
print("TS:")
print(TS)

inputs=DS[,1:lags]
output=DS[,(lags+1)]

# elman network: 1 input lag, 2 hidden layers with 5 and 3 hidden nodes, 1 output node:
EL=elman(inputs[TR,"lag1"],output[TR],size=c(5,3),learnFuncParams=c(0.1),maxit=200)
# show training error convergence:
plotIterativeError(EL)

# target
Y=S[H$ts] # real observed values

# only 1 input is used, predict wants a data.frame or matrix (10x1):
tinputs=data.frame(lag1=inputs[TS,"lag1"])
PEL=predict(EL,tinputs)
# rescale back to original space:
PEL=(PEL*RANGE)+MIN

# show forecasting measures and graph:
cat("EL predictions: ")
cat("NMAE=",mmetric(Y,PEL,metric="NMAE",val=srange),"\n")

D=CasesSeries(S,c(1:11)) # 11 time lags t-1,t-2,t-3,t-4,t-5,t-6,t-7,t-8,t-9,t-10,t-11 -> t
# fit a Neural Network (NN) - multilayer perceptron ensemble: 
NN=rminer::fit(y~.,D[TR,],model="mlpe",search="heuristic") # 11 time lags
NN1=rminer::fit(y~.,D[TR,c("lag1","y")],model="mlpe",search="heuristic")

PNN=predict(NN,D[TS,])
# only 1 input is used, predict wants a data.frame or matrix (10x1):
tdts=data.frame(lag1=D[TS,"lag1"])
PNN1=predict(NN1,tdts)

# show forecasting measures and graph:
cat("NN predictions: ")
cat("NMAE=",mmetric(Y,PNN,metric="NMAE",val=srange),"\n")
cat("NN1 predictions: ")
cat("NMAE=",mmetric(Y,PNN1,metric="NMAE",val=srange),"\n")

# graph:
print("Graph with NN predictions (1-ahead):")
plot(1:length(Y),Y,ylim=c(min(PEL,PNN,Y),max(PEL,PNN,Y)),type="b",col="black")
lines(PEL,type="b",col="blue",pch=2)
lines(PNN,type="b",col="red",pch=3)
lines(PNN1,type="b",col="brown",pch=3)
legend("topright",c("Sunspots","EL","NN","NN1"),pch=c(1,2,3,3),col=c("black","blue","red","brown"))

# important notes: this script can be run several times by using:
# source("2-sunspots.R")
# 
# EL produces similar results to NN but NN1 is substantially worse than NN and EL.
# this occurs because EL is a recurrent network and can store internaly (memorize) previous lags.
# while NN is feedforward, not recurrent and thus needs the up to 11 lags input info.
# 
# the advantage of EL is that it can be applied to a different time series with no need to set the time lags.
# NN requires the definition of the CasesSeries lags (W parameter, in this demo: W=1:11)
