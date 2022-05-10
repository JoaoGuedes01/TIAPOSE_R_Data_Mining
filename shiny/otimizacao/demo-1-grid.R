source("blind.R") # fsearch is defined here
source("grid.R") #  gsearch is defined here
# dimension
D=3

# evaluation function:
sphere=function(x) sum(x^2)

lower=rep(-10.4,D) # lower bounds
upper=rep(10.4,D) #  upper bounds
# grid search 10x10 search ( length(seq(-10.4,10.4,by=2.1)== 10 ):
GS=gsearch(fn=sphere,lower=lower,upper=upper,step=c(2.1,2.1,2.1),type="min")
cat("best solution:",GS$sol,"evaluation function",GS$eval,"\n")
