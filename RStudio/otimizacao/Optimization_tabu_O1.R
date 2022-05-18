library(tabuSearch)

# global variables (can be used inside the functions):
# dimension
D=1 # 1 parameters solution
BITS=35 # bits per parameter, sets the real value precision and affects the solution size
LIM=1 # upper and lower bound
Low=0
Up=LIM

#Read file
data = read.csv("store.csv", header = TRUE, sep=";")

#Create dimension of time series
all = data[251:257,2]
female = data[251:257,3]
male = data[251:257,4]
young = data[251:257,5]
adult = data[251:257,6]

pred=c(all, female, male, young, adult)

# variables
DW=7 #days of the week
cost=c(rep(350,DW),rep(150,DW),rep(100,DW),rep(100,DW),rep(120,DW))
solution=sample(c(0,1), replace=TRUE, size=BITS)


# evaluation function:
eval=function(x) profit(x)

profit=function(x) 
{ 
  x = round(x)
  vendas=sales(x)
  p=sum(x*(vendas-cost))
  return(p)
}

sales=function(x)
{
  res=rep(0,D) #initial solution
  
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

N=100 # number of iterations

size=D*BITS # solution size is D*BITS

s=tabuSearch(size,iters=N,objFunc=eval,config=solution,verbose=TRUE)
b=which.max(s$eUtilityKeep) # best index
bs=s$configKeep[b,]
cat("best solution:",bs,"evaluation function",s$eUtilityKeep[b],"\n")
