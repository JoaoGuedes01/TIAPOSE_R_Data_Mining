source("hill.R") #  hclimbing is defined here

#Ler ficheiro
data = read.csv("store.csv", header = TRUE, sep=";")

#Create dimension of time series
all = data[251:257,2]
female = data[251:257,3]
male = data[251:257,4]
young = data[251:257,5]
adult = data[251:257,6]

pred=(c(all, female, male, young, adult))
#pred=(c(all=all, female=female, male=male, young=young, adult=adult))
#pred=c(4974,3228,3191,4153,4307,4660,6193,2299,1442,1427,2035,2043,2207,2894,2390,1606,1627,1880,2028,2227,2967,2680,1625,1688,2208,2282,2441,3115,2294,1603,1503,1945,2025,2219,3078)


# variables
D=35 #dimension
N=7 #days of the week
custo=c(rep(350,N),rep(150,N),rep(100,N),rep(100,N),rep(120,N))
solution=solution=sample(c(0,1), replace=TRUE, size=D)


# evaluation function:
#eval=function(x) profit(x)

profit=function(x) 
{ 
  vendas=sales(pred)
  p=sum(x*(vendas-custo))
  return(p)
}

sales= function(x)
{
  vector=c()
  for (i in 1:length(x)) {
    if(i<36){
      if(x[i]<800) sale=0.08*x[i] else sale=0.12*x[i]
    }
    if(i<29){
      if(x[i]<3000) sale=0.04*x[i] else sale=0.05*x[i]
    }
    if(i<22){
      if(x[i]<1800) sale=0.04*x[i] else sale=0.07*x[i]
    }
    if(i<15){
      if(x[i]<1800) sale=0.08*x[i] else sale=0.13*x[i]
    }
    if(i<8){
      if(x[i]<5000) sale=0.06*x[i] else sale=0.09*x[i]
    }
    vector <- c(vector, sale)
  }
  return(vector)
}

# hill climbing search
N=1000 # 1000 searches
REPORT=N/20 # report results
lower=rep(0,D) # lower bounds
upper=rep(1,D) #  upper bounds


# slight change of a real par under a normal u(0,0.5) function:
rchange1=function(par,lower,upper) # change for hclimbing
{ hchange(par,lower=lower,upper=upper,rnorm,mean=0,sd=0.5,round=TRUE) }

HC=hclimbing(par=solution,fn=profit,change=rchange1,lower=lower,upper=upper,type="max",
             control=list(maxit=N,REPORT=REPORT,digits=2))
cat("best solution:",HC$sol,"evaluation function",HC$eval,"\n")

