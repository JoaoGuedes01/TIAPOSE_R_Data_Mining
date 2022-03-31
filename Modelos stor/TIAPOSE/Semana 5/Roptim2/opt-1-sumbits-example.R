# you need to install this package:
library(genalg)

# string is a vector of binary 0 or 1 values
# rbga.bin always performs a minimization task, thus the sum of bits ( sum(string) )is transformed 
# into a minimization task using: K - eval(S):
evaluate=function(string=c()) 
{ return ( length(string) - sum(string)) }

# genetic algorithm for a binary representation with a size of 24 bits, each bit is 0 or 1:
bga= rbga.bin(size=24, popSize=20, mutationChance=0.01, zeroToOneRatio=1,elitism=0,evalFunc=evaluate,iter=20)

# visual example of the evolution of the rbga.bin optimization
plot(bga)
