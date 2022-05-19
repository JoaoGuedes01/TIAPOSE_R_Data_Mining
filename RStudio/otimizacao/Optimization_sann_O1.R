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

# variables
D=35 #dimension
DW=7 #days of the week
cost=c(rep(350,DW),rep(150,DW),rep(100,DW),rep(100,DW),rep(120,DW))
solution=sample(c(0,1), replace=TRUE, size=D)


# evaluation function:
eval=function(x) profit(x)

profit=function(x) 
{ 
  x = round(x)
  vendas=sales(x)
  p=sum(x*(vendas-cost))
  v = sum(x==1)
  s = p/v
  return(s)
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


lower=rep(0,D) # lower bounds
upper=rep(1,D) # upper bounds
Runs=100

best= -Inf # - infinity
for(i in 1:Runs)
{
  #rchange1=function(par) # change for hclimbing
  #{ hchange(par,lower=lower ,upper=upper, rnorm, mean=0, sd=1, round=TRUE) }
  
  
  rchange1=function(par) # change for hclimbing
  { hchange(par,lower=lower,upper=upper,rnorm,mean=0,sd=0.5,round=TRUE) }
  
  sa= optim(solution ,fn=eval,method="SANN", gr=rchange1, control=list(maxit=100, temp=6000, trace=FALSE))
  L=eval(sa$par)
  cat("execution:",i," solution:",round(sa$par)," profit:",L,"\n")
  if(L>best) { BESTSA=sa; best=L;}
}
cat("Best Solution: ",BESTSA$par,"profit:",eval(BESTSA$par),"\n")

