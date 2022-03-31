# you need to install these packages:
library(genalg)
library(DEoptim)
library(pso)

# definition of the famous rastrigin function
# x is a vector with D real values.
rastrigin=function(x=c()) { return (sum(x^2-10*cos(2*pi*x)+10))}

# global variables, defined outside functions: ------------------------
# lets set D to 30 (good benchmark, challenging):
D=30
LIM=5.12 # used for lower and upper bounds, global variable
#----------------------------------------------------------------------

# some parameters that will be equal for all methods:
popSize=100 # population size
iter=100 # maximum number of iterations
report=10 # report progress every 10 iterations
lower=rep(-LIM,D) # lower bounds for all D values
upper=rep(LIM,D)  # upper bounds for all D values

## set a seed first for replicability (all computers will have the same sequence of random numbers):
  set.seed(1234)

## show best:
showbest=function(method,par,eval)
{ cat("method:",method,"\n > par:",par,"\n > eval:",eval,"\n") }


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
rga=rbga(lower,upper,popSize=popSize,evalFunc=rastrigin,iter=iter,monitor=traceGA) 
# get the best solution:
# note: the way to get the best solution and evaluation depends on the implementation of the method and thus
# it can be different from method to method:
PMIN=which.min(rga$evaluations)
showbest("rbga",rga$population[PMIN,],rga$evaluations[PMIN])

# Differential Evolution Optimization: -------------------------
de=DEoptim(fn=rastrigin,lower=lower,upper=upper,DEoptim.control(NP=popSize,itermax=iter,trace=report))
# get the best solution:
# note: the way to get the best solution and evaluation depends on the implementation of the method and thus
# it can be different from method to method:
showbest("DEoptim",de$optim$bestmem,de$optim$bestval)

# Particle Swarm Optimization: ---------------------------------
# note: par needs to be vector with the size of D, in this case I am using lower, but upper could also be used.
# the values of par are not used.
ps=psoptim(par=lower,fn=rastrigin,lower=lower,upper=upper,control=list(trace=1,REPORT=report,maxit=iter,s=popSize))
# get the best solution:
# note: the way to get the best solution and evaluation depends on the implementation of the method and thus
# it can be different from method to method:
showbest("psoptim",ps$par,ps$value)
