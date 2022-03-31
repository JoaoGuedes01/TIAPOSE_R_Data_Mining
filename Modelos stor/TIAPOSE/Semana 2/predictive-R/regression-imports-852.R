# regression demo: incremental and rolling window (also known as "backtesting")

# "Read the automobile data:"
d=read.table("imports-85.csv",sep=",",header=TRUE,na.strings="?",stringsAsFactors=TRUE)
# Delete missing examples:"
d=na.omit(d)
# "Select some attributes:"
AT=c(2,6,8:26)
d=d[,AT]
cat("full dataset with:",nrow(d),"x",ncol(d),"\n")

# lets assume data is ordered through time:
library(rminer)

print("incremental window training demonstration:")
Test=20;S=10;W=109 # examples
YR=diff(range(d$V26)) # global Y range, use the same for NMAE calculation
ev=vector(length=5)
trinit=1
for(b in 1:5)  # iterations
{
 H=holdout(d$V26,ratio=Test,mode="incremental",iter=b,window=W,increment=S)
 M=fit(V26~.,d[H$tr,],model="randomForest")
 P=predict(M,d[H$ts,])
 ev[b]=mmetric(d$V26[H$ts],P,"NMAE",val=YR)
 cat("iter:",b,"TR from:",trinit,"to:",(trinit+length(H$tr)-1),"size:",length(H$tr),
       "TS from:",(length(H$tr)+1),"to:",(length(H$tr)+length(H$ts)),"size:",length(H$ts),
       "nmae:",ev[b],"\n")
}
cat(round(ev,digits=2))
cat("\n")
cat("mean of metric:",round(mean(ev),digits=2),"\n")
cat("median of metric:",round(median(ev),digits=2),"\n")

print("rolling window training demonstration:")
ev2=vector(length=5)
for(b in 1:5)  # iterations
{
 H=holdout(d$V26,ratio=Test,mode="rolling",iter=b,window=W,increment=S)
 M=fit(V26~.,d[H$tr,],model="randomForest")
 P=predict(M,d[H$ts,])
 trinit=(b-1)*S+1
 trend=(trinit+length(H$tr)-1)
 tsinit=trend+1
 tsend=tsinit+length(H$ts)-1
 ev2[b]=mmetric(d$V26[H$ts],P,"NMAE",val=YR)
 cat("iter:",b,"TR from:",trinit,"to:",trend,"size:",length(H$tr),
      "TS from:",tsinit,"to:",tsend,"size:",length(H$ts),
       "nmae:",ev2[b],"\n")
 #print(d[H$tr[1],])
 #print(d[H$ts[1],])
}
cat(round(ev2,digits=2))
cat("\n")
cat("mean of metric:",round(mean(ev2),digits=2),"\n")
cat("median of metric:",round(median(ev2),digits=2),"\n")
