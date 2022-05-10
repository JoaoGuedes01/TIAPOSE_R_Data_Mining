# --------- Product Sales example ----------
eval=function(x) -profit(x)

profit=function(x,cost_per_unit=c(10,15)) 
{ 
  v=sales(x)
  c=cost(v,cost_per_unit)
  profit=sum(v*x-c)
  return(profit)
}
cost=function(units,cpu)
{
 c=100+cpu*units
 return(c)
}
sales= function(x)
{
  p=(1000/log(x+200)-140) 
  return(round(p,digits=0))
}


# simulated annealing:
Runs=10

cat("Simulated Annealing (example with",Runs,"different seeds/runs): \n")
x=sample(1:1000,Runs)
y=sample(1:1000,Runs)

best= -Inf # - infinity
for(i in 1:Runs)
{
 sa= optim(c(x[i],y[i]),fn=eval,method="SANN",control=list(maxit=6000, temp=2000, trace=FALSE))
 L=profit(sa$par)
 cat("execution:",i," solution:",round(sa$par)," profit:",L,"\n")
 if(L>best) { BESTSA=sa; best=L;}
}
cat(">> Solution: ",round(BESTSA$par),"profit:",profit(BESTSA$par)," sales:",sales(BESTSA$par),"\n")
