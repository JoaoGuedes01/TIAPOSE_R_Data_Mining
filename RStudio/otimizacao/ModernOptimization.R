# you need to install these packages:
library(genalg)
library(DEoptim)
library(pso)

## set a seed first for replicability (all computers will have the same sequence of random numbers):
#set.seed(1234)

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
lower = rep(0,D) # lower bounds
upper = rep(1,D) #  upper bounds


#----------------------------------------------------------------------

# some parameters that will be equal for all methods:
popSize=100 # population size
iter=100 # maximum number of iterations
report=10 # report progress every 10 iterations


## show best:
showbest=function(method,par,eval)
{ cat("method:",method,"\n > par:",round(par),"\n > eval:",round(eval),"\n") }


# Genetic Algorithm optimization: ------------------------------
ITER<<- 1 # global variable with number of rbga iterations
# monitoring function:
traceGA=function(obj)
{ if((ITER %% report)==0) # show progress every report iterations
{ PMIN=which.min(obj$evaluations)
cat("iter:",ITER," eval:",obj$evaluations[PMIN],"\n")
}
  ITER<<-ITER+1
}
# call to rbga: Genetic Algorithm:
rga=rbga(lower,upper,popSize=popSize,evalFunc=eval,iter=iter,monitor=traceGA) 
# get the best solution:
# note: the way to get the best solution and evaluation depends on the implementation of the method and thus
# it can be different from method to method:
PMIN=which.min(rga$evaluations)
showbest("rbga",rga$population[PMIN,],rga$evaluations[PMIN])

# Differential Evolution Optimization: -------------------------
de=DEoptim(fn=eval,lower=lower,upper=upper,DEoptim.control(NP=popSize,itermax=iter,trace=report))
# get the best solution:
# note: the way to get the best solution and evaluation depends on the implementation of the method and thus
# it can be different from method to method:
showbest("DEoptim",de$optim$bestmem,de$optim$bestval)

# Particle Swarm Optimization: ---------------------------------
# note: par needs to be vector with the size of D, in this case I am using lower, but upper could also be used.
# the values of par are not used.
ps=psoptim(par=lower,fn=eval,lower=lower,upper=upper,control=list(trace=1,REPORT=report,maxit=iter,s=popSize))
# get the best solution:
# note: the way to get the best solution and evaluation depends on the implementation of the method and thus
# it can be different from method to method:
showbest("psoptim",ps$par,ps$value)

