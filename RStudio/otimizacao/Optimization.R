source("hill.R") #  hclimbing is defined here
source("blind.R") # fsearch is defined here
source("montecarlo.R") # mcsearch is defined here
library(tabuSearch)
#set.seed(1234)

#Para executar este ficheiro é necessário escolher o modelo pretendidoe o objetivo de otimização
#Ex: Para o objetivo 1 utilizando o hill climbing usa-se:
#hill(profit1)


#Read file
data = read.csv("store.csv", header = TRUE, sep=";")

#Create dimension of time series
all = data[251:257,2]
female = data[251:257,3]
male = data[251:257,4]
young = data[251:257,5]
adult = data[251:257,6]

pred = c(all, female, male, young, adult)

# variables
D = 35 #dimension
DW = 7 #days of the week
Runs = 100 # number of searches
cost = c(rep(350,DW),rep(150,DW),rep(100,DW),rep(100,DW),rep(120,DW)) #time series cost
solution = sample(c(0,1), replace=TRUE, size=D) #initial solution
lower = rep(0,D) # lower bounds
upper = rep(1,D) #  upper bounds


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


# evaluation function:
#O1
profit1 <- function(x) 
{ 
  x = round(x)
  p = sum(x*(vendas-cost))
  return(p)
}

#O2 death penalty
profit21 <- function(x) 
{ 
  x = round(x)
  p = sum(x*(vendas-cost))
  
  #promotions limits
  if(sum(x==1)>10){
    p = -99999
  }
  return(p)
}

#O2 repair
profit22 <- function(x) 
{ 
  x = round(x)
  x = repairSolution(x)
  p = sum(x*(vendas-cost))
  
  return(p)
}


#Repair Function
repairSolution <- function(x) {
  n = 0
  for(i in 1:length(x)){
    if(x[i] == 1 & n < 10)
      n = n + 1
    else 
      x[i] = 0  
  }
  return(x)
}

#O3
profit3 <- function(x) 
{ 
  x = round(x)
  p = sum(x*(vendas-cost))
  v = sum(x==1)
  if(v==0) v=35
  s = p/v
  return(s)
}


#Optimization hill climbing
hill <- function(evalF) 
{
  REPORT = Runs/20 # report results
  
  # slight change of a real par under a normal u(0,0.5) function:
  rchange1=function(par,lower,upper) # change for hclimbing
  { hchange(par,lower=lower,upper=upper,rnorm,mean=0,sd=0.5,round=TRUE) }
  
  HC = hclimbing(par=solution,fn=evalF,change=rchange1,lower=lower,upper=upper,type="max",
                 control=list(maxit=Runs,REPORT=REPORT,digits=2))
  cat("best solution:",HC$sol,"evaluation function",HC$eval,"\n")
  return(HC$eval)
}


#Optimization montecarlo
montecarlo <- function(evalF) 
{
  
  # monte carlo search 
  MC=mcsearch(fn=evalF,lower=lower,upper=upper,N=Runs,type="max")
  cat("best solution:",round(MC$sol),"evaluation function",MC$eval,"\n")
  return(MC$eval)
}


#Optimization sann
sann <- function(evalF) 
{
  
  best= -Inf # - infinity
  for(i in 1:Runs)
  {
    rchange2=function(par) # change for hclimbing
    { hchange(par,lower=lower,upper=upper,rnorm,mean=0,sd=0.5,round=TRUE) }
    
    sa= optim(solution ,fn=evalF,method="SANN", gr=rchange2, control=list(maxit=100, temp=6000, trace=FALSE))
    L=evalF(sa$par)
    cat("execution:",i," solution:",round(sa$par)," profit:",L,"\n")
    if(L>best) { BESTSA=sa; best=L;}
  }
  cat("Best Solution: ",BESTSA$par,"profit:",evalF(BESTSA$par),"\n")
  return(evalF(BESTSA$par))
}


#Optimization tabu
tabu <- function(evalF) 
{
  LIM = 1 # upper and lower bound
  lower = 0
  upper = LIM
  
  s=tabuSearch(size = D,iters=Runs,objFunc=evalF,config=solution,verbose=TRUE)
  b=which.max(s$eUtilityKeep) # best index
  bs=s$configKeep[b,]
  cat("best solution:",bs,"evaluation function",s$eUtilityKeep[b],"\n")
  return(s$eUtilityKeep[b])
}

#Runs each model n times for comparison
RunAll = function(eval, n){
  
  hillV=c()
  monteV=c()
  sannV=c()
  tabuV=c()
  
  for (i in 1:n) {
    h = hill(eval)
    hillV <- c(hillV, h)
    
    m = montecarlo(eval)
    monteV <- c(monteV, m)
    
    s = sann(eval)
    sannV <- c(sannV, s)
    
    t = tabu(eval)
    tabuV <- c(tabuV, t)
  }
  
  hill1=sum(hillV)/n
  monte1=sum(monteV)/n
  sann1=sum(sannV)/n
  tabu1=sum(tabuV)/n
  
  cat("\nHill O1:", hill1)
  cat("\nMontecarlo O1:", monte1)
  cat("\nSANN O1:", sann1)
  cat("\nTabu O1:", tabu1)
}


#Runs
#H1 = hill(profit1)
#H2 = hill(profit22)
#H3 = hill(profit3)
#S1 = sann(profit1)
#S2 = sann(profit22)
#S3 = sann(profit3)
#M1 = montecarlo(profit1)
#M2 = montecarlo(profit22)
#M3 = montecarlo(profit3)
#T1 = tabu(profit1)
#T2 = tabu(profit22)
#T3 = tabu(profit3)
