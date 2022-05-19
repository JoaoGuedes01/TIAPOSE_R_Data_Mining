source("blind.R") # fsearch is defined here
source("montecarlo.R") # mcsearch is defined here
# variables
D=7
pred=c(4974, 3228, 3191, 4153, 4307, 4660, 6193)
custo=350
solution=c(1, 0, 0, 1, 0, 1, 1)

# evaluation function:
eval=function(x) profit(x)

profit=function(x) 
{ 
  vendas=sales(pred)
  custo=350
  p=sum(x*(vendas-custo))
  return(p)
}

sales= function(x)
{
  sale=ifelse(x<5000, x*0.06, x*0.09)
  return(sale)
}

N=100000 # number of searches
# monte carlo search 
lower=rep(0,D) # lower bounds
upper=rep(1,D) #  upper bounds
MC=mcsearch(fn=eval,lower=lower,upper=upper,N=N,type="max")
cat("best solution:",MC$sol,"evaluation function",MC$eval,"\n")

