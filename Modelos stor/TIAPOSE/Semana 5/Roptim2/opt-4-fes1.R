# you need to install this package:
library(mco) # load mco package

# real value FES1 benchmark (see Cortez, 2014, Modern Optimization with R, Springer)
fes1=function(x)
{ D=length(x);f1=0;f2=0
  for(i in 1:D)
  { 
	f1=f1+abs(x[i]-exp((i/D)^2)/3)^0.5
   	f2=f2+(x[i]-0.5*cos(10*pi/D)-0.5)^2 
  }
  return(c(f1,f2))
}

m=2 # there are 2 objectives
# example retrieved from the book "Modern Optimization with R", 2014, Springer:
D=8 # dimension
cat("real value task:\n")
G=nsga2(fn=fes1,idim=D,odim=m,
        lower.bounds=rep(0,D),upper.bounds=rep(1,D),
        popsize=20,generations=1:100)
# show best individuals:
I=which(G[[100]]$pareto.optimal)
for(i in I)
{
 x=round(G[[100]]$par[i,],digits=2); cat(x)
 cat(" f=(",round(fes1(x)[1],2),",",round(fes1(x)[2],2),")",
     "\n",sep="")
}
# create PDF with Pareto front evolution:
pdf(file="nsga-fes1.pdf",paper="special",height=5,width=5)
par(mar=c(4.0,4.0,0.1,0.1))
I=1:100
for(i in I)
{ P=G[[i]]$value # objectives f1 and f2
  # color from light gray (75) to dark (1):
  COL=paste("gray",round(76-i*0.75),sep="")
  if(i==1) plot(P,xlim=c(0.5,5.0),ylim=c(0,2.0),
                xlab="f1",ylab="f2",cex=0.5,col=COL)
  Pareto=P[G[[i]]$pareto.optimal,]
  # sort Pareto according to x axis:
  points(P,type="p",pch=1,cex=0.5,col=COL)
  if(is.matrix(Pareto)) # if Pareto has more than 1 point
    { I=sort.int(Pareto[,1],index.return=TRUE)
      Pareto=Pareto[I$ix,]
      lines(Pareto,type="l",cex=0.5,col=COL)
    }
}
dev.off()
