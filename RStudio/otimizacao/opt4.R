#Read file
data = read.csv("store.csv", header = TRUE, sep=";")

#Create dimension of time series
all = data[251:257,2]
female = data[251:257,3]
male = data[251:257,4]
young = data[251:257,5]
adult = data[251:257,6]

pred=c(all=all, female=female, male=male, young=young, adult=adult)
D = 35
solution=sample(c(0,1), replace=TRUE, size=D)

# you need to install this package:
library(mco) # load mco package

# real value FES1 benchmark (see Cortez, 2014, Modern Optimization with R, Springer)
fes1=function(x) c(-profit1(round(x)), sum(round(x)))

# evaluation function:
eval <- function(x) -profit1(x)

profit1 <- function(x) 
{ 
  x = round(x)
  p = sum(x*(vendas-cost))
  return(p)
}

profit2 <- function(x) 
{ 
  x = round(x)
  p = sum(x*(vendas-cost))
  
  #promotions limits
  if(sum(x==1)>10){
    p = -99999
  }
  return(p)
}

profit3 <- function(x) 
{ 
  x = round(x)
  p = sum(x*(vendas-cost))
  v = sum(x==1)
  s = p/v
  return(s)
}

#Sales function
sales <- function()
{
  res = rep(0,D) #initial solution
  
  for (i in 1:7) {
    if(pred[i]<5000) res[i]=0.06*pred[i] else res[i]=0.09*pred[i] #all
  }
  
  for (i in 8:14) {
    if(pred[i]<1800) res[i]=0.08*pred[i] else res[i]=0.13*pred[i] #female
  }
  
  for (i in 15:21) {
    if(pred[i]<1800) res[i]=0.04*pred[i] else res[i]=0.07*pred[i] #male
  }
  
  for (i in 22:28) {
    if(pred[i]<3000) res[i]=0.04*pred[i] else res[i]=0.05*pred[i] #young
  }
  
  for (i in 29:35) {
    if(pred[i]<800) res[i]=0.08*pred[i] else res[i]=0.12*pred[i] #adult
  }
  return(res)
}
vendas=sales()

m=2 # there are 2 objectives
# example retrieved from the book "Modern Optimization with R", 2014, Springer:
#D=8 # dimension
cat("real value task:\n")
G=nsga2(fn=fes1,idim=D,odim=m,
        lower.bounds=rep(0,D),upper.bounds=rep(1,D),
        popsize=20,generations=1:100)
# show best individuals:
I=which(G[[100]]$pareto.optimal)
for(i in I)
{
 x=round(G[[100]]$par[i,],digits=0); cat(x)
 cat(" f=(",abs(round(fes1(x)[1],2)),",",round(fes1(x)[2],2),")",
     "\n",sep="")
}
# create PDF with Pareto front evolution:
pdf(file="nsga-fes1.pdf",paper="special",height=5,width=5)
par(mar=c(4.0,4.0,0.1,0.1))
I=1:100
for(i in I)
{ G[[i]]$value[,1] <- abs(G[[i]]$value[,1])
  P=G[[i]]$value # objectives f1 and f2
  
  vec = c()
  #for(b in 1:20){
  #  campanhas <- sum(round(G[[i]]$par[b,])==1)
  #  lucro <- abs(G[[i]]$value[b])
  #  vec  <- c(vec, c(campanhas, lucro))
  #}
  #P = matrix( 
  #  vec,
  #  ncol=2,
  #  byrow = TRUE)
   #color from light gray (75) to dark (1):
  COL=paste("gray",round(76-i*0.75),sep="")
  if(i==1) plot(P,xlim=c(0,3000),ylim=c(0,35),
                xlab="Campanhas",ylab="Lucro",cex=1,col=COL)
  Pareto=P[G[[i]]$pareto.optimal,]
  # sort Pareto according to x axis:
  points(P,type="p",pch=1,cex=1,col=COL)
  if(is.matrix(Pareto)) # if Pareto has more than 1 point
    { I=sort.int(Pareto[,1],index.return=TRUE)
      Pareto=Pareto[I$ix,]
      lines(Pareto,type="l",cex=1,col=COL)
    }
}
dev.off()
