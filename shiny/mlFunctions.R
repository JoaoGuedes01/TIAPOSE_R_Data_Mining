# Importar Libraries
library(tidyverse)
library(rminer)
library(forecast)



# --------------------------------------------- Modeling -------------------------------------------------------
# test "2013-05-14"
getWeek = function(date){
  # get index of specific date
  initial = which(dates == date)
  final = initial + 6
  dayRange = c(initial:final)
  week = dates[dayRange,]
  res <- list(initial = initial, final = final,week=week)
  return(res)
}


initVars = function(){
  dates <<- read.csv(file = './extra/date.csv')["x"]
  timeSeries <<- c("all","female","male","young","adult")
  models_rminer <<- c("lm","mlpe","naive","ctree","mlp","randomForest","mr","rvm","ksvm")
  models_forecast <<- c("HW","Arima","NN","ETS")
  print("Variables Initialized")
}
# Initialize necessary vars
initVars()


loadData = function(cen){
  switch(  
    cen,  
    "cen1"= {folder = "Cenario 1"},
    "cen2"= {folder = "Cenario 2"},
    "cen3"= {folder = "Cenario 3"}
  )
  path_ts1 = paste(as.character("cenarios"),folder,as.character("TS1.csv"),sep = "\\")
  ts1 <<- read.csv(file = path_ts1)
  ts1 <<- subset (ts1, select = -X)
  
  path_ts2 = paste(as.character("cenarios"),folder,as.character("TS2.csv"),sep = "\\")
  ts2 <<- read.csv(file = path_ts2)
  ts2 <<- subset (ts2, select = -X)
  
  path_ts3 = paste(as.character("cenarios"),folder,as.character("TS3.csv"),sep = "\\")
  ts3 <<- read.csv(file = path_ts3)
  ts3 <<- subset (ts3, select = -X)
  
  path_ts4 = paste(as.character("cenarios"),folder,as.character("TS4.csv"),sep = "\\")
  ts4 <<- read.csv(file = path_ts4)
  ts4 <<- subset (ts4, select = -X)
  
  path_ts5 = paste(as.character("cenarios"),folder,as.character("TS5.csv"),sep = "\\")
  ts5 <<- read.csv(file = path_ts5)
  ts5 <<- subset (ts5, select = -X)
}

parseDF = function(df,chosen){
  data = df
  removed = data[chosen,]
  data = data[- chosen,]
  res = rbind(data,removed)
  row.names(res) <- NULL
  return(res)
}

MultivariateModel = function(cen,pmodel,day){
  loadData(cen)
  # Create Dataframe for Prediction Storage
  preds <- data.frame(matrix(ncol = 8, nrow = 0))
  # Name the Columns
  colnames(preds) <- c('ts','v1','v2','v3','v4','v5','v6','v7')
  
  days = getWeek(day)
  
  # Holdout based on selected week
  allIndex = c(1:nrow(dates))
  semanaEsc = c(days$initial:days$final) #101-107
  tr = allIndex[-semanaEsc]
  ts = semanaEsc
  
  for (t in 1:length(timeSeries)){
    currentTS = timeSeries[t]
    switch(  
      currentTS,  
      "all"= {data=ts1 ; target = all~.},
      "female"= {data=ts2; target = female~.},
      "male"= {data=ts3; target = male~.},
      "young"= {data=ts4; target = young~.},
      "adult"= {data=ts5; target = adult~.},
    )
    
    # Creating the Model and making the predictions
    M=fit(target,data[tr,],model=pmodel)
    Pred=predict(M,data[ts,])
    preds[nrow(preds) + 1,] = c(timeSeries[t],Pred[1],Pred[2],Pred[3],Pred[4],Pred[5],Pred[6],Pred[7])
  }
  print(preds)
}



UnivariateModel = function(cen,model,week){
  # Load the Datasets
  loadData(cen)
  
  # Create Dataframe for Prediction Storage
  preds <- data.frame(matrix(ncol = 8, nrow = 0))
  # Name the Columns
  colnames(preds) <- c('ts','v1','v2','v3','v4','v5','v6','v7')
  

  if(model %in% models_forecast){
    for (t in 1:length(timeSeries)){
      currentTS = timeSeries[t]
      switch(  
        currentTS,  
        "all"= {data=ts1},
        "female"= {data=ts2},
        "male"= {data=ts3},
        "young"= {data=ts4},
        "adult"= {data=ts5},
      )
      
      d1 = data[,1] # coluna target
      L = length(d1)
      K=7
      Test = K
      
      data = parseDF(data,week)
      H=holdout(data[,1],ratio=7,mode="order")
      dtr = ts(d1[H$tr],frequency=K)
      switch(  
        model,  
        "HW"= {M = suppressWarnings(HoltWinters(dtr))},
        "Arima"= {M = suppressWarnings(auto.arima(dtr))},
        "NN"= {M = suppressWarnings(nnetar(dtr,p=7))},
        "ETS"= {M = suppressWarnings(ets(dtr))},
      )  
      Pred = forecast(M,h=length(H$ts))$mean[1:Test]
      preds[nrow(preds) + 1,] = c(timeSeries[t],Pred[1],Pred[2],Pred[3],Pred[4],Pred[5],Pred[6],Pred[7])
      
    }
    print(preds)
    return(preds)
  }else{
    for (t in 1:length(timeSeries)){
      currentTS = timeSeries[t]
      switch(  
        currentTS,  
        "all"= {data=ts1},
        "female"= {data=ts2},
        "male"= {data=ts3},
        "young"= {data=ts4},
        "adult"= {data=ts5},
      )
      
      data = parseDF(data,week)
      
      d1 = data[,1] # coluna target
      L = length(d1)
      K=7
      Test = K
      
      timelags = c(1:7)
      D = CasesSeries(d1,timelags)
      
      H=holdout(data[,1],ratio=7,mode="order")
      
      M = fit(y~.,D[H$tr,],model=model)
      Pred = lforecast(M,D,start=(length(H$tr)+1),Test)
      preds[nrow(preds) + 1,] = c(timeSeries[t],Pred[1],Pred[2],Pred[3],Pred[4],Pred[5],Pred[6],Pred[7])
    }
    print(preds)
    return(preds)
  }

}

# Best Hybrid Model (HW + LM)
HybridModel = function(day){
  days = getWeek(day)
  
  # Create Dataframe for Prediction Storage
  preds <- data.frame(matrix(ncol = 8, nrow = 0))
  predsUI <- data.frame(matrix(ncol = 8, nrow = 0))
  # Name the Columns
  colnames(preds) <- c('ts','v1','v2','v3','v4','v5','v6','v7')
  colnames(predsUI) <- c("Time Series", as.array(days$week))
  
  
  
  # Holdout based on selected week
  allIndex = c(1:nrow(dates))
  semanaEsc = c(days$initial:days$final) #101-107
  tr = allIndex[-semanaEsc]
  ts = semanaEsc
  
  K=7
  Test=K # H, the number of multi-ahead steps, adjust if needed
  S=K # step jump: set in this case to 7 predictions
 
  
  for (t in 1:length(timeSeries)){
    currentTS = timeSeries[t]
    switch(  
      currentTS,  
      "all"= {data=ts1},
      "female"= {data=ts2},
      "male"= {data=ts3},
      "young"= {data=ts4},
      "adult"= {data=ts5},
    ) 
    cat("TS:",currentTS,"\n")
    
    d1 = data[,1] # 1ª coluna
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
    
    cat("Predictions:",Pred2,"\n")
    cat("MAE:",mae,"\n")
    cat("NMAE:",nmae,"\n")
    
    preds[nrow(preds) + 1,] = c(timeSeries[t],Pred2[1],Pred2[2],Pred2[3],Pred2[4],Pred2[5],Pred2[6],Pred2[7])
    predsUI[nrow(predsUI) + 1,] = c(timeSeries[t],Pred2[1],Pred2[2],Pred2[3],Pred2[4],Pred2[5],Pred2[6],Pred2[7])
  }
  res <- list(preds = preds, predsUI = predsUI)
  print(res)
  return(res)
}

# --------------------------------------------- Optimization -------------------------------------------------------

# Hill Climbing
hillClimbing = function(preds){
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
  best = HC$sol
  res = list(ts1=best[1:7],ts2=best[8:14],ts3=best[15:21],ts4=best[22:28],ts5=best[29:35])
  return(res)
}






