# you need to install this package:
library(genalg)

# definition of the famous rastrigin function
# x is a vector with D real values.
rastrigin=function(x=c()) { return (sum(x^2-10*cos(2*pi*x)+10))}

# rbga accepts the possibility to execute a monitor function, defined by the user.
# obj$population contains the population of the rbga alfgorithm
# the monitor function is executed in every iteration (generation) of the algorithm.
# in this case, monitor will plot the search space for D=2, 
# where the points color will get darker as the generations increase:

monitor=function(obj) {
    xlim = c(-LIM,LIM) # x-axis limits
    ylim = c(-LIM,LIM) # y-axis limits
    COL=paste("gray",80-ITER*4,sep="") # set the points color depending on ITER

    for(i in 1:nrow(obj$population))
      cat(obj$population[i,]," fit:",obj$evaluations[i],"\n") # show in console all individual values and fitness
    PMIN=which.min(obj$evaluations) # show which point provides the best (lowest) value
    cat("PMIN:",PMIN,"\n")

    plot(obj$population, xlim=xlim, ylim=ylim, xlab="x", ylab="y",pch=19,cex=0.5,col=COL) # plot all points
    #plot(obj$population, xlim=xlim, ylim=ylim, xlab="x", ylab="y",pch=19,cex=sizepop(obj$evaluations));
    text(obj$population[PMIN,1],obj$population[PMIN,2],"min") # put the label "min" near the best point
    cat("-- generation:",ITER,"(press enter)\n");readLines(n=1) # wait for user to press enter
    ITER<<-ITER+1 # global variable ITER increase (outside this function, ITER is valid)
}

LIM=5.12 # used for lower and upper bounds, global variable

# first experiment, popSize=20:
ITER<<-1 # global variable assignment (because monitor only receives obj as input)
rga=rbga(c(-LIM,-LIM),c(LIM,LIM),popSize=20,mutationChance=0.33,elitism=1, evalFunc=rastrigin, monitorFunc=monitor, iter=20) 
plot(rga)

# second experiment, popSize=2000:
ITER<<-1 # global variable assignment (because monitor only receives obj as input)
rga=rbga(c(-LIM,-LIM),c(LIM,LIM),popSize=2000,mutationChance=0.33,elitism=1, evalFunc=rastrigin, monitorFunc=monitor, iter=20) 
plot(rga)


