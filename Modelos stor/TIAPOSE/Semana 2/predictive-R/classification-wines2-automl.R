# AUTOML classification demo
library(rminer)
library(tictoc)
# classification demo, using wine quality from UCI:
path="https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/"
file=paste(path,"winequality-white.csv",sep="")
w=read.table(file,sep=";",header=TRUE)
w$quality=cut(w$quality,c(0,5.5,6.5,10),c("bad","medium","good"))

# to speed up results, lets work on a smaller dataset sample size: 1000 rows
s=1:1000
w=w[s,]

# lets assume a simple time ordered holdout split:
H=holdout(w$quality,ratio=2/3,mode="order")
# tr = total training data
# ts = total test data

print("### automl (faster) ###")
# use of auto-ml, mode 1 (faster): "automl"
inputs=ncol(w)-1 # number of inputs, needed for random forest
metric="macroF1" 

sm=mparheuristic(model="automl",task="prob",inputs=inputs)
# internal validation method (used within the training data)
imethod=c("holdoutorder",2/3) # internal validation method
search=list(search=sm,smethod="auto",method=imethod,metric=metric,convex=0)

# external validation method:
emethod=holdout(w$quality,2/3,mode="order") # object with tr and ts indexes
# emethod$tr - training data rows

# execution of 1 run of the fast automl1:
print("automl1 fit:")
tic()
M=fit(quality~.,data=w[emethod$tr,],model="auto",search=search,fdebug=TRUE)
# emethod$ts - test data rows
toc()
P=predict(M,w[emethod$ts,])

# show leaderboard:
cat("> leaderboard models:",M@mpar$LB$model,"\n")
cat(">  validation values:",round(M@mpar$LB$eval,4),"\n")
cat("best model is:",M@model,"\n")
cat("test set ",metric,"=",round(mmetric(w$quality[emethod$ts],P,metric=metric),2),"\n")

print("### automl3 (might provide better results, requires more computation) ###")
# use of auto-ml, mode 3: "automl3"
sm3=mparheuristic(model="automl3",task="prob",inputs=inputs)
# internal validation method (used within the training data)
search3=list(search=sm3,smethod="auto",method=imethod,metric=metric,convex=0)

# execution of 1 run of the fast automl1:
print("automl3 fit:")
tic()
M3=fit(quality~.,data=w[emethod$tr,],model="auto",search=search3,fdebug=TRUE)
toc()
# emethod$ts - test data rows
P3=predict(M3,w[emethod$ts,])

# show leaderboard:
cat("> leaderboard models:",M3@mpar$LB$model,"\n")
cat(">  validation values:",round(M3@mpar$LB$eval,4),"\n")
cat("best model is:",M3@model,"\n")
cat("test set ",metric,"=",round(mmetric(w$quality[emethod$ts],P3,metric=metric),2),"\n")
