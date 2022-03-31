library(rminer) # powerful rminer 
library(rpart.plot) # plot nice decision trees
library(tictoc) # timer

# classification demo, using wine quality from UCI:
path="https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/"
file=paste(path,"winequality-white.csv",sep="")
w=read.table(file,sep=";",header=TRUE)
w$quality=cut(w$quality,c(0,5.5,6.5,10),c("bad","medium","good"))

# save transformed data into a new csv: wq3.csv (bad,medium,good):"
write.table(file="wq3.csv",w,row.names=FALSE,col.names=TRUE,sep=";") 

# lets assume that the order of the samples is based on time,
# where first instances are older samples and
# the last instances are the newer ones.

# simple time ordered holdout split
H=holdout(w$quality,ratio=2/3,mode="order")
# tr = total training data
# ts = total test data

cat("fit a decision tree:\n")
tic()
dt=fit(quality~.,w[H$tr,],model="dt")
toc()

# show decision tree:
rpart.plot(dt@object)

# fit a SVM with no hyperparameter tuning:
cat("fit a SVM:\n")
tic()
svm=fit(quality~.,w[H$tr,],model="ksvm")
toc()
# show main svm model:
print(svm@object)

# fit a SVM with some hyperparameter tuning:
# training data is further divided into fit (2/3) and validation sets (1/3)
# "UD" - is a special uniform design with 13 searches for the Gaussian SVM hyperparameters (C and sigma)
cat("fit SVM2 (uniform design search):\n")
tic()
s=list(search=mparheuristic("ksvm",5),method=c("holdoutorder",2/3))
svm2=fit(quality~.,w[H$tr,],model="ksvm",search=s)
toc()
print(svm2@object)

# analysis of the quality of the predictions on the test set:
pdt=predict(dt,w[H$ts,])
psvm=predict(svm,w[H$ts,])
psvm2=predict(svm2,w[H$ts,])
Y=w[H$ts,]$quality # target output variable

print("classification metrics:")
cat("class. metrics for dt:")
print(mmetric(Y,pdt,metric=c("ACC","AUC","macroF1","ACCLASS","AUCCLASS","F1")))
cat("class. metrics for svm:")
print(mmetric(Y,psvm,metric=c("ACC","AUC","macroF1","ACCLASS","AUCCLASS","F1")))
cat("class. metrics for svm2:")
print(mmetric(Y,psvm2,metric=c("ACC","AUC","macroF1","ACCLASS","AUCCLASS","F1")))

# examples of confusion matrices:
print("dt confusion matrix:")
print(mmetric(Y,pdt,metric="CONF")$conf)
print("dt confusion matrix for class good:")
print(mmetric(Y,pdt,TC=3,metric="CONF")$conf)
print("dt confusion matrix for class good and D=0.7:") # more specific model
print(mmetric(Y,pdt,TC=3,D=0.6,metric="CONF")$conf)
print("dt confusion matrix for class good and D=0.3:") # more sensitive model
print(mmetric(Y,pdt,TC=3,D=0.3,metric="CONF")$conf)

# ROC curves:
# simple ROC curve for svm target class good (TC=3):
mgraph(Y,psvm,graph="ROC",TC=3,baseline=TRUE,leg="Good",Grid=10)
# more elaborated ROC curve:
L=vector("list",3) # needed because of mgraph multi ROC plot
testl=vector("list",1);testl[[1]]=Y # same TEST target for all 3 models
p1=vector("list",1);p1[[1]]=pdt
p2=vector("list",1);p2[[1]]=psvm
p3=vector("list",1);p3[[1]]=psvm2
L[[1]]=list(pred=p1,test=testl,runs=1)
L[[2]]=list(pred=p2,test=testl,runs=1)
L[[3]]=list(pred=p3,test=testl,runs=1)
auc1=round(mmetric(Y,pdt,metric="AUC",TC=3),digits=2)
auc2=round(mmetric(Y,psvm,metric="AUC",TC=3),digits=2)
auc3=round(mmetric(Y,psvm2,metric="AUC",TC=3),digits=2)
leg=c(paste("dt (AUC=",auc1,")",sep=""),paste("svm (AUC=",auc2,")",sep=""),paste("svm2 (AUC=",auc3,")",sep=""))
mgraph(L,graph="ROC",TC=3,baseline=TRUE,leg=list(pos="bottomright",leg=leg),main="ROC for Good",Grid=10)

# LIFT curves (useful for marketing tasks):
# simple LIFT curve for svm target class good (TC=3):
mgraph(Y,psvm,graph="LIFT",TC=3,baseline=TRUE,leg="Good",Grid=10)
# more elaborated LIFT curve:
# in this example, a new pdf file is created:
pdf("wine-lift.pdf",width=5,height=5) # diverts graph to PDF
L=vector("list",3) # needed because of mgraph multi ROC plot
testl=vector("list",1);testl[[1]]=Y # same TEST target for all 3 models
p1=vector("list",1);p1[[1]]=pdt
p2=vector("list",1);p2[[1]]=psvm
p3=vector("list",1);p3[[1]]=psvm2
L[[1]]=list(pred=p1,test=testl,runs=1)
L[[2]]=list(pred=p2,test=testl,runs=1)
L[[3]]=list(pred=p3,test=testl,runs=1)
auc1=round(mmetric(Y,pdt,metric="ALIFT",TC=3),digits=2)
auc2=round(mmetric(Y,psvm,metric="ALIFT",TC=3),digits=2)
auc3=round(mmetric(Y,psvm2,metric="ALIFT",TC=3),digits=2)
leg=c(paste("dt (ALIFT=",auc1,")",sep=""),paste("svm (ALIFT=",auc2,")",sep=""),paste("svm2 (ALIFT=",auc3,")",sep=""))
mgraph(L,graph="LIFT",TC=3,baseline=TRUE,leg=list(pos=c(0.4,0.3),leg=leg),main="LIFT for Good",Grid=10)
dev.off() # closes PDF
