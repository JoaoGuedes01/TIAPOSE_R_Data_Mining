source("hill.R") #  hclimbing is defined here
# dimension
D=5

# evaluation function:
sphere=function(x) sum(x^2)

# hill climbing search
N=1000 # 100 searches
REPORT=N/20 # report results
lower=rep(-10.4,D) # lower bounds
upper=rep(10.4,D) #  upper bounds

#set.seed(125)
# slight change of a real par under a normal u(0,0.5) function:
rchange1=function(par,lower,upper) # change for hclimbing
{ hchange(par,lower=lower,upper=upper,rnorm,mean=0,sd=0.5,round=FALSE) }

HC=hclimbing(par=rep(-10.4,D),fn=sphere,change=rchange1,lower=lower,upper=upper,type="min",
             control=list(maxit=N,REPORT=REPORT,digits=2))
cat("best solution:",HC$sol,"evaluation function",HC$eval,"\n")
