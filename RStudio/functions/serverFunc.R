# Importar Libraries
library(tidyverse)
library(rminer)
library(forecast)


ts1 <- read.csv(file = './cenarios/Cenario 1/TS1.csv')
ts2 <- read.csv(file = './cenarios/Cenario 1/TS2.csv')
ts3 <- read.csv(file = './cenarios/Cenario 1/TS3.csv')
ts4 <- read.csv(file = './cenarios/Cenario 1/TS4.csv')
ts5 <- read.csv(file = './cenarios/Cenario 1/TS5.csv')

ts1 = ts1 %>% select(-X)
ts2 = ts2 %>% select(-X)
ts3 = ts3 %>% select(-X)
ts4 = ts4 %>% select(-X)
ts5 = ts5 %>% select(-X)




predict = function(week){
  week="1_2_3_4_5_6_7"
  weeksplit = strsplit(week,"_")
  print(weeksplit)
  weekvector = unlist(weeksplit[1])
  print(weekvector[1])
  
  allIndex = c(1:nrow(ts1))
  semanaEsc = weekvector
  tr = as.numeric(allIndex)[-as.numeric(semanaEsc)]
  ts = as.numeric(semanaEsc)
  
  print("TR")
  print(tr)
  print("TS")
  print(ts)
  
  # Hybrid Model
  # Create Dataframe for Prediction Storage
  preds <- data.frame(matrix(ncol = 8, nrow = 0))
  # Name the Columns
  colnames(preds) <- c('ts','v1','v2','v3','v4','v5','v6','v7')
  
  
  K=7
  Test=K # H, the number of multi-ahead steps, adjust if needed
  S=K # step jump: set in this case to 7 predictions
  timeSeries = c("all","female","male","young","adult")
  
  for (t in 1:length(timeSeries)){
    
    switch(  
      t,  
      "all"= {data=ts1},
      "female"= {data=ts2},
      "male"= {data=ts3},
      "young"= {data=ts4},
      "adult"= {data=ts5},
    ) 
    # print("TS:",timeSeries[t],"\n")
    
    d1 = data[,1] # coluna all
    L = length(d1) # 257
    
    # rminer:
    timelags=c(1:7) # 1 previous day until 7 previous days
    D=CasesSeries(d1,timelags) # note: nrow(D) is smaller by max timelags than length(d1)
    
    YR=diff(range(d1)) # global Y range, use the same range for the NMAE calculation in all iterations
    
    
    dtr = ts(d1[tr],frequency=K)
    M = suppressWarnings(HoltWinters(dtr)) 
    PrevPred = M$fitted[1:nrow(M$fitted)]
    Pred = forecast(M,h=length(ts))$mean[1:Test]
    
    # Creating a Dataframe with all univariate predictions
    uniPred = c(PrevPred,Pred)
    HD = cbind(uniPred=uniPred,ts1[1:length(uniPred),2:5],y=d1[1:length(uniPred)])
    HD = data.frame(HD)
    
    TRSIZE=length(PrevPred)
    LPRED=length(Pred)
    RSIZE=TRSIZE+LPRED
    
    # Creating Multivariate Model with new Dataframe
    M2=fit(y~.,HD[1:TRSIZE,],model="lm") # create forecasting model
    Pred2=predict(M2,HD[(TRSIZE+1):(RSIZE),]) # multi-step ahead forecasts
    mae=mmetric(y=d1[ts],x=Pred2,metric="MAE",val=YR)
    nmae=mmetric(y=d1[ts],x=Pred2,metric="NMAE",val=YR)
    
    #print("Predictions:",Pred2,"\n")
    #print("MAE:",mae,"\n")
    #print("NMAE:",nmae,"\n")
    
    preds[nrow(preds) + 1,] = c(timeSeries[t],Pred2[1],Pred2[2],Pred2[3],Pred2[4],Pred2[5],Pred2[6],Pred2[7])     
    
  }
  
  # Optimization(Hill Climbing)
  
  source("./otimizacao/hill.R") #  hclimbing is defined here
  
  #Create dimension of time series
  all = unlist(preds[1,])[-1]
  female = unlist(preds[2,])[-1]
  male = unlist(preds[3,])[-1]
  young = unlist(preds[4,])[-1]
  adult = unlist(preds[5,])[-1]
  
  pred=as.numeric((c(all, female, male, young, adult)))
  #pred=(c(all=all, female=female, male=male, young=young, adult=adult))
  #pred=c(4974,3228,3191,4153,4307,4660,6193,2299,1442,1427,2035,2043,2207,2894,2390,1606,1627,1880,2028,2227,2967,2680,1625,1688,2208,2282,2441,3115,2294,1603,1503,1945,2025,2219,3078)
  
  
  # variables
  D=35 #dimension
  N=7 #days of the week
  custo=c(rep(350,N),rep(150,N),rep(100,N),rep(100,N),rep(120,N))
  solution=solution=sample(c(0,1), replace=TRUE, size=D)
  
  
  # evaluation function:
  #eval=function(x) profit(x)
  
  profit=function(x) 
  { 
    vendas=sales(pred)
    p=sum(x*(vendas-custo))
    return(p)
  }
  
  sales= function(x)
  {
    vector=c()
    for (i in 1:length(x)) {
      if(i<36){
        if(x[i]<800) sale=0.08*x[i] else sale=0.12*x[i]
      }
      if(i<29){
        if(x[i]<3000) sale=0.04*x[i] else sale=0.05*x[i]
      }
      if(i<22){
        if(x[i]<1800) sale=0.04*x[i] else sale=0.07*x[i]
      }
      if(i<15){
        if(x[i]<1800) sale=0.08*x[i] else sale=0.13*x[i]
      }
      if(i<8){
        if(x[i]<5000) sale=0.06*x[i] else sale=0.09*x[i]
      }
      vector <- c(vector, sale)
    }
    return(vector)
  }
  
  # hill climbing search
  N=1000 # 1000 searches
  REPORT=N/20 # report results
  lower=rep(0,D) # lower bounds
  upper=rep(1,D) #  upper bounds
  
  
  # slight change of a real par under a normal u(0,0.5) function:
  rchange1=function(par,lower,upper) # change for hclimbing
  { hchange(par,lower=lower,upper=upper,rnorm,mean=0,sd=0.5,round=TRUE) }
  
  HC=hclimbing(par=solution,fn=profit,change=rchange1,lower=lower,upper=upper,type="max",
               control=list(maxit=N,REPORT=REPORT,digits=2))
  cat("best solution:",HC$sol,"evaluation function",HC$eval,"\n")
  
  
  
  res = c(tr,ts)
  return('ok')
}
predict(1)

