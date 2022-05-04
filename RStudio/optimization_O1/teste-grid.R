source("blind.R") # fsearch is defined here
source("grid.R") #  gsearch is defined here
# dimension
D=7

pred=c(4974, 3228, 3191, 4153, 4307, 4660, 6193)
solution=c(1, 0, 0, 1, 0, 1, 0)
solution1=c(1, 0, 0, 1, 0, 1, 1)

# evaluation function:
eval=function(x) profit(x)

profit=function(x, pred=c(4974, 3228, 3191, 4153, 4307, 4660, 6193)) 
{ 
  vendas=sales(pred)
  custo=350
  profit=sum(x*(vendas-custo))
  return(profit)
}

sales= function(pred)
{
  sale=ifelse(pred<5000, pred*0.06, pred*0.09)
  return(sale)
}

lower=rep(1,D) # lower bounds
upper=rep(0,D) #  upper bounds
# 
GS=gsearch(fn=eval,lower=lower,upper=upper,step=solution,type="max")
cat("solution:",GS$sol,"evaluation function",GS$eval,"\n")

