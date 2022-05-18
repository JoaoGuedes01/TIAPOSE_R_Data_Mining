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
cost = c(rep(350,DW),rep(150,DW),rep(100,DW),rep(100,DW),rep(120,DW))
solution = sample(c(0,1), replace=TRUE, size=D)


# evaluation function:
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
lower = rep(0,D) # lower bounds
upper = rep(1,D) #  upper bounds


#Optimization hill climbing
hill <- function(evalF) 
{
  N = 1000 # 1000 searches
  REPORT = N/20 # report results
  
  
  # slight change of a real par under a normal u(0,0.5) function:
  rchange1=function(par,lower,upper) # change for hclimbing
  { hchange(par,lower=lower,upper=upper,rnorm,mean=0,sd=0.5,round=TRUE) }
  
  HC = hclimbing(par=solution,fn=evalF,change=rchange1,lower=lower,upper=upper,type="max",
                 control=list(maxit=N,REPORT=REPORT,digits=2))
  cat("best solution:",HC$sol,"evaluation function",HC$eval,"\n")
}


#Optimization montecarlo
montecarlo <- function(evalF) 
{
  N = 100000 # number of searches
  
  # monte carlo search 
  MC=mcsearch(fn=evalF,lower=lower,upper=upper,N=N,type="max")
  cat("best solution:",round(MC$sol),"evaluation function",MC$eval,"\n")
}


#Optimization sann
sann <- function(evalF) 
{
  Runs = 100
  
  best= -Inf # - infinity
  for(i in 1:Runs)
  {
    #rchange1=function(par) # change for hclimbing
    #{ hchange(par,lower=lower ,upper=upper, rnorm, mean=0, sd=1, round=TRUE) }
    
    
    rchange2=function(par) # change for hclimbing
    { hchange(par,lower=lower,upper=upper,rnorm,mean=0,sd=0.5,round=TRUE) }
    
    sa= optim(solution ,fn=evalF,method="SANN", gr=rchange2, control=list(maxit=100, temp=6000, trace=FALSE))
    L=evalF(sa$par)
    cat("execution:",i," solution:",round(sa$par)," profit:",L,"\n")
    if(L>best) { BESTSA=sa; best=L;}
  }
  cat("Best Solution: ",BESTSA$par,"profit:",evalF(BESTSA$par),"\n")
}


#Optimization tabu
tabu <- function(evalF) 
{
  LIM = 1 # upper and lower bound
  lower = 0
  upper = LIM
  size = D
  N = 100 # number of iterations
  
  s=tabuSearch(size,iters=N,objFunc=evalF,config=solution,verbose=TRUE)
  b=which.max(s$eUtilityKeep) # best index
  bs=s$configKeep[b,]
  cat("best solution:",bs,"evaluation function",s$eUtilityKeep[b],"\n")
}


#Runs
cat("\nObjetivo 1:\n")
#H1 = hill(profit1)
#H2 = hill(profit2)
#H3 = hill(profit3)
#S1 = sann(profit1)
#S2 = sann(profit2)
#S3 = sann(profit3)
#M1 = montecarlo(profit1)
#M2 = montecarlo(profit2)
#M3 = montecarlo(profit3)
#T1 = tabu(profit1)
#T2 = tabu(profit2)
#T3 = tabu(profit3)
