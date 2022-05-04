library(tabuSearch)

# global variables (can be used inside the functions):
# dimension
D=1 # 1 parameters solution
BITS=7 # bits per parameter, sets the real value precision and affects the solution size
LIM=1 # upper and lower bound
Low=0
Up=LIM
pred=c(4974, 3228, 3191, 4153, 4307, 4660, 6193)
custo=350
solution=c(1, 0, 0, 1, 0, 1, 0)

# evaluation function:
eval=function(x) -profit(x)

profit=function(x,) 
{ 
  vendas=sales(pred)
  #custo = 350*length(which(x==1))
  #p=sum(x*vendas)-custo
  custo=350
  p=sum(x*(vendas-custo))
  return(p)
}

sales= function(pred)
{
  sale=ifelse(x<5000, x*0.06, x*0.09)
  return(sale)
}


N=100 # number of iterations

size=D*BITS # solution size is D*BITS

s=tabuSearch(size,iters=N,objFunc=eval,config=solution,verbose=TRUE)
b=which.max(s$eUtilityKeep) # best index
bs=s$configKeep[b,]
cat("best solution:",bs ,"evaluation function",K-s$eUtilityKeep[b],"\n")

