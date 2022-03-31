# regression demo:

# "Read the automobile data:"
d=read.table("imports-85.csv",sep=",",header=TRUE,na.strings="?",stringsAsFactors=TRUE)
print(summary(d))

# Delete missing examples:"
d=na.omit(d)
print(summary(d))

# "Select some attributes:"
AT=c(2,4,5,6,7,8,14,22,23,26)
d=d[,AT]
print(summary(d))

cat("full dataset with:",nrow(d),"x",ncol(d),"\n")

# lets assume data is ordered through time:
library(rminer)

# simpler holdout ordered split, usage of powerful mining function:
# 10 executions of the same model: "mr" - multiple linear regression
MR=mining(V26~.,d,model="mr",Runs=10,method=c("holdouto",2/3))
cat("total time elapsed:",sum(MR$time),"s\n")

# 10 executions of the same model: "mlpe" - ensemble of MLP
NN=mining(V26~.,d,model="mlpe",Runs=10,method=c("holdouto",2/3))
cat("median size (hidden nodes) value:",centralpar(NN$mpar)$size,"\n")
cat("total time elapsed:",sum(NN$time),"s\n")

# 10 executions of the same model: "mlpe" - ensemble of MLP
SV=mining(V26~.,d,model="ksvm",Runs=10,method=c("holdouto",2/3))

# 10 executions of the same model: "mlpe" - ensemble of MLP
RF=mining(V26~.,d,model="randomForest",Runs=10,method=c("holdouto",2/3))

# prediction (test set) results:
# average MAE metric and t-student confidence interval:"
eMR=mmetric(MR,metric="NMAE")
m1=meanint(eMR)
cat("MR NMAE average=:",m1$mean,"+-",m1$int,"%\n")
eNN=mmetric(NN,metric="NMAE")
m2=meanint(eNN)
cat("NN NMAE average=:",m2$mean,"+-",m2$int,"%\n")
eSV=mmetric(SV,metric="NMAE")
m3=meanint(eSV)
cat("SV NMAE average=:",m3$mean,"+-",m3$int,"%\n")
eRF=mmetric(RF,metric="NMAE")
m4=meanint(eRF)
cat("RF NMAE average=:",m4$mean,"+-",m4$int,"%\n")

# show scatter plot for RD:
mgraph(RF,graph="RSC",main="RF",baseline=TRUE,Grid=10)

# REC curve comparison:
L=vector("list",4); 
L[[1]]=MR
L[[2]]=NN
L[[3]]=SV
L[[4]]=RF
leg=c("MR","NN","SVM","RF")
mgraph(L,graph="REC",main="REC curves",leg=leg,baseline=TRUE,Grid=10)
