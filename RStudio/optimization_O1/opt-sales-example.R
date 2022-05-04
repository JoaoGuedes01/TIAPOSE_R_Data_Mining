# --------- Variáveis ----------
pred=c(4974, 3228, 3191, 4153, 4307, 4660, 6193)
custo=350
solution=c(1, 0, 0, 1, 0, 1, 0)

# --------- Product Sales example ----------
eval=function(x) -profit(x)

profit=function(x) 
{ 
  vendas=sales(pred)
  profit=sum(x*(vendas-custo))
  p=sum(x*vendas)-custo
  return(profit)
}

sales= function(pred)
{
  sale=ifelse(pred<5000, pred*0.06, pred*0.09)
  return(sale)
}


# simulated annealing:
Runs=10

cat("Simulated Annealing (example with",Runs,"different seeds/runs): \n")
x=solution

best= -Inf # - infinity
for(i in 1:Runs)
{
 sa= optim(x[i],fn=eval,method="SANN",control=list(maxit=6000, temp=2000, trace=FALSE))
 L=profit(sa$par)
 cat("execution:",i," solution:",round(sa$par)," profit:",L,"\n")
 if(L>best) { BESTSA=sa; best=L;}
}
cat(">> Solution: ",round(BESTSA$par),"profit:",profit(BESTSA$par)," sales:",sales(BESTSA$par),"\n")

