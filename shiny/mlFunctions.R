# Importar Libraries
library(tidyverse)
library(rminer)
library(forecast)

source("Optimization.R")

# --------------------------------------------- Modeling -------------------------------------------------------


Holdout <- function(week){
  selected <- c(week)
  rest <- c(1:(selected[1] - 1))
  res <- list(tr=rest,ts=selected)
}


# test "2013-05-14"
getWeek = function(weekNumber){
  init = 36
  resInit <- 7 * (weekNumber-1) + init
  resFinal <- resInit + 6
  res <- c(resInit:resFinal)
  return(res)
}

getWeekDays = function(week){
  res = dates[week,]
  return(res)
}


initVars = function(){
  dates <<- read.csv(file = './extra/date.csv')["x"]
  all_data <<- read.csv(file = './extra/TodosDadosTab.csv')
  all_data <<- subset (all_data, select = -X)
  timeSeries <<- c("all","female","male","young","adult")
  timeSeries_list <<- list("all"=1,"female"=2,"male"=3,"young"=4,"adult"=5)
  models_rminer <<- c("lm","mlpe","naive","ctree","mlp","randomForest","mr","rvm","ksvm")
  models_forecast <<- c("HW","Arima","NN","ETS")
  weeks <<- list(
    "Week 6" = 1,
    "week 7" = 2,
    "week 8" = 3,
    "week 9" = 4,
    "week 10" = 5,
    "week 11" = 6,
    "week 12" = 7,
    "week 13"= 8,
    "week 14" = 9,
    "week 15" = 10,
    "week 16" = 11,
    "week 17" = 12,
    "week 18" = 13,
    "week 19" = 14,
    "week 20" = 15,
    "week 21" = 16,
    "week 22" = 17,
    "week 23" = 18,
    "week 24" = 19,
    "week 25" = 20,
    "week 26" = 21,
    "week 27" = 22,
    "week 28" = 23,
    "week 29" = 24,
    "week 30" = 25,
    "week 31" = 26,
    "week 32" = 27,
    "week 33" = 28,
    "week 34" = 29,
    "week 35" = 30,
    "week 36" = 31
  )
  
  
  

  
  print("Variables Initialized")
}
# Initialize necessary vars
initVars()

loadResults = function(cen,model,ts){
  ts = paste("TS",ts,".csv",sep = "")
  path = paste(as.character("./resultados"),cen,model,ts,sep = "/")
  print(path)
  results_df <<- read.csv(file = path)
  return(results_df)
  #results_df <<- subset (results_df, select = -X)
}

#a = loadResults("Cenario 1", "Modelos Hibridos",2)


loadData = function(cen){
  switch(  
    cen,  
    "cen1"= {folder = "Cenario 1"},
    "cen2"= {folder = "Cenario 2"},
    "cen3"= {folder = "Cenario 3"}
  )
  path_ts1 = paste(as.character("./cenarios"),folder,as.character("TS1.csv"),sep = "/")
  ts1 <<- read.csv(file = path_ts1)
  ts1 <<- subset (ts1, select = -X)
  
  path_ts2 = paste(as.character("./cenarios"),folder,as.character("TS2.csv"),sep = "/")
  ts2 <<- read.csv(file = path_ts2)
  ts2 <<- subset (ts2, select = -X)
  
  path_ts3 = paste(as.character("./cenarios"),folder,as.character("TS3.csv"),sep = "/")
  ts3 <<- read.csv(file = path_ts3)
  ts3 <<- subset (ts3, select = -X)
  
  path_ts4 = paste(as.character("./cenarios"),folder,as.character("TS4.csv"),sep = "/")
  ts4 <<- read.csv(file = path_ts4)
  ts4 <<- subset (ts4, select = -X)
  
  path_ts5 = paste(as.character("./cenarios"),folder,as.character("TS5.csv"),sep = "/")
  ts5 <<- read.csv(file = path_ts5)
  ts5 <<- subset (ts5, select = -X)
}

MultivariateModel = function(cen,model,week){
  loadData(cen)
  # Create Dataframe for Prediction Storage
  preds <- data.frame(matrix(ncol = 8, nrow = 0))
  # Name the Columns
  colnames(preds) <- c('ts','v1','v2','v3','v4','v5','v6','v7')
  
  H = Holdout(week)
  print(H$tr)
  print(H$ts)
  
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
    M = fit(target,data[H$tr,],model=model)
    Pred = predict(M,data[H$ts,])
    prev = data[H$tr,][,1]
    #print(prev)
    
    assign(paste0(timeSeries[t],"_prevs"),prev)
    
    Pred = round(Pred)
    
    preds[nrow(preds) + 1,] = c(timeSeries[t],Pred[1],Pred[2],Pred[3],Pred[4],Pred[5],Pred[6],Pred[7])
  }
  res = list(
    preds=preds,
    all_prevs=all_prevs,
    female_prevs=female_prevs,
    male_prevs=male_prevs,
    young_prevs=young_prevs,
    adult_prevs=adult_prevs)
  
  print(res)
  return(res)
}


UnivariateModel = function(cen,model,week){
  # Load the Datasets
  loadData(cen)
  
  # Create Dataframe for Prediction Storage
  preds <- data.frame(matrix(ncol = 8, nrow = 0))
  # Name the Columns
  colnames(preds) <- c('ts','v1','v2','v3','v4','v5','v6','v7')
  
  residuals = c()
  
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
    
    H = Holdout(week)
    print(H$tr)
    print(H$ts)
    
    if(model %in% models_forecast){
      dtr = ts(d1[H$tr],frequency=K)
      switch(  
        model,  
        "HW"= {M = suppressWarnings(HoltWinters(dtr))},
        "Arima"= {M = suppressWarnings(auto.arima(dtr))},
        "NN"= {M = suppressWarnings(nnetar(dtr,p=7))},
        "ETS"= {M = suppressWarnings(ets(dtr))},
      )  
      fcast <<- forecast(M,h=length(H$ts))
      Pred = fcast$mean[1:Test]
      Pred = round(Pred)
      preds[nrow(preds) + 1,] = c(timeSeries[t],Pred[1],Pred[2],Pred[3],Pred[4],Pred[5],Pred[6],Pred[7])
    }else{
      timelags = c(1:7)
      D = CasesSeries(d1,timelags)
      
      M = fit(y~.,D[H$tr,],model=model)
      Pred = lforecast(M,D,start=(length(H$tr)+1),Test)
      Pred = round(Pred)
      preds[nrow(preds) + 1,] = c(timeSeries[t],Pred[1],Pred[2],Pred[3],Pred[4],Pred[5],Pred[6],Pred[7])
      plot(Pred)
    }
    prev = data[H$tr,][,1]
    assign(paste0(timeSeries[t],"_prevs"),prev)
  }
  #res = list(Preds = preds, fcast = fcast)
  res = list(
    preds=preds,
    all_prevs=all_prevs,
    female_prevs=female_prevs,
    male_prevs=male_prevs,
    young_prevs=young_prevs,
    adult_prevs=adult_prevs)
  
  print(res)
  return(res)
}

# Best Hybrid Model (HW + LM)
HybridModel = function(cen,week,model_uni,model_multi){
  # Load the Datasets
  loadData(cen)
  
  # Create Dataframe for Prediction Storage
  preds <- data.frame(matrix(ncol = 8, nrow = 0))
  
  # Name the Columns
  colnames(preds) <- c('ts','v1','v2','v3','v4','v5','v6','v7')
  
  H = Holdout(week)
  print(H$tr)
  print(H$ts)
 
  
  for (t in 1:length(timeSeries)){
    currentTS = timeSeries[t]
    switch(  
      currentTS,  
      "all"= {data=ts1; target = all~.},
      "female"= {data=ts2; target = female~.},
      "male"= {data=ts3; target = male~.},
      "young"= {data=ts4; target = young~.},
      "adult"= {data=ts5; target = adult~.},
    )
    d1 = data[,1] # coluna target
    L = length(d1)
    K=7
    Test = K
    
    if(model_uni %in% models_forecast){
      
      dtr = ts(d1[H$tr],frequency=K)
      switch(  
        model_uni,  
        "HW"= {M <<- suppressWarnings(HoltWinters(dtr)); PrevPred <<- M$fitted[1:nrow(M$fitted)]},
        "Arima"= {M <<- suppressWarnings(auto.arima(dtr)); PrevPred <<- fitted(M)},
        "NN"= {M <<- suppressWarnings(nnetar(dtr,p=7)); PrevPred <<- M$fitted[8:length(M$fitted)]},
        "ETS"= {M <<- suppressWarnings(ets(dtr)); PrevPred <<- fitted(M)},
      ) 
      Pred <<- forecast(M,h=length(H$ts))$mean[1:Test]
      
    }else{
      
      # Creating the Model and making the predictions
      M <<- fit(target,data[H$tr,],model=model_uni)
      Pred <<- predict(M,data[H$ts,])
    }

    # Creating a Dataframe with all univariate predictions
    uniPred = c(PrevPred,Pred)
    HD = cbind(uniPred=uniPred,ts1[1:length(uniPred),2:5],y=d1[1:length(uniPred)])
    HD = data.frame(HD)
    
    TRSIZE=length(PrevPred)
    LPRED=length(Pred)
    RSIZE=TRSIZE+LPRED
    
    # Creating Multivariate Model with new Dataframe
    M2=fit(y~.,HD[1:TRSIZE,],model=model_multi) # create forecasting model
    Pred2=predict(M2,HD[(TRSIZE+1):(RSIZE),]) # multi-step ahead forecasts
    
    Pred2 = round(Pred2)
    
    preds[nrow(preds) + 1,] = c(timeSeries[t],Pred2[1],Pred2[2],Pred2[3],Pred2[4],Pred2[5],Pred2[6],Pred2[7])
    prev = data[H$tr,][,1]
    assign(paste0(timeSeries[t],"_prevs"),prev)
  }
  res = list(
    preds=preds,
    all_prevs=all_prevs,
    female_prevs=female_prevs,
    male_prevs=male_prevs,
    young_prevs=young_prevs,
    adult_prevs=adult_prevs)
  
  print(res)
  return(res)
}



HybridModel_Single = function(cen,week,model_uni,model_multi,selTS){
  # Load the Datasets
  loadData(cen)
  
  # Create Dataframe for Prediction Storage
  preds <- data.frame(matrix(ncol = 8, nrow = 0))
  
  # Name the Columns
  colnames(preds) <- c('ts','v1','v2','v3','v4','v5','v6','v7')
  
  H = Holdout(week)
  print(H$tr)
  print(H$ts)
  
    switch(  
      selTS,  
      "all"= {data=ts1; target = all~.},
      "female"= {data=ts2; target = female~.},
      "male"= {data=ts3; target = male~.},
      "young"= {data=ts4; target = young~.},
      "adult"= {data=ts5; target = adult~.},
    )
    d1 = data[,1] # coluna target
    L = length(d1)
    K=7
    Test = K
    
    if(model_uni %in% models_forecast){
      
      dtr = ts(d1[H$tr],frequency=K)
      switch(  
        model_uni,  
        "HW"= {M <<- suppressWarnings(HoltWinters(dtr)); PrevPred <<- M$fitted[1:nrow(M$fitted)]},
        "Arima"= {M <<- suppressWarnings(auto.arima(dtr)); PrevPred <<- fitted(M)},
        "NN"= {M <<- suppressWarnings(nnetar(dtr,p=7)); PrevPred <<- M$fitted[8:length(M$fitted)]},
        "ETS"= {M <<- suppressWarnings(ets(dtr)); PrevPred <<- fitted(M)},
      ) 
      Pred <<- forecast(M,h=length(H$ts))$mean[1:Test]
      
    }else{
      
      # Creating the Model and making the predictions
      M <<- fit(target,data[H$tr,],model=model_uni)
      Pred <<- predict(M,data[H$ts,])
    }
    
    # Creating a Dataframe with all univariate predictions
    uniPred = c(PrevPred,Pred)
    HD = cbind(uniPred=uniPred,ts1[1:length(uniPred),2:5],y=d1[1:length(uniPred)])
    HD = data.frame(HD)
    
    TRSIZE=length(PrevPred)
    LPRED=length(Pred)
    RSIZE=TRSIZE+LPRED
    
    # Creating Multivariate Model with new Dataframe
    M2=fit(y~.,HD[1:TRSIZE,],model=model_multi) # create forecasting model
    Pred2=predict(M2,HD[(TRSIZE+1):(RSIZE),]) # multi-step ahead forecasts
    
    Pred2 = round(Pred2)
    
    #preds[nrow(preds) + 1,] = c(selTS,Pred2[1],Pred2[2],Pred2[3],Pred2[4],Pred2[5],Pred2[6],Pred2[7])
    preds = c(selTS,Pred2)
    prev = data[H$tr,][,1]
  
  res = list(
    preds=preds,
    prev=prev)
  
  print(res)
  return(res)
}

MultiModel_Single = function(cen,week,model,selTS){
  loadData(cen)
  # Create Dataframe for Prediction Storage
  preds <- data.frame(matrix(ncol = 8, nrow = 0))
  # Name the Columns
  colnames(preds) <- c('ts','v1','v2','v3','v4','v5','v6','v7')
  
  H = Holdout(week)
  print(H$tr)
  print(H$ts)
  
    switch(  
      selTS,  
      "all"= {data=ts1 ; target = all~.},
      "female"= {data=ts2; target = female~.},
      "male"= {data=ts3; target = male~.},
      "young"= {data=ts4; target = young~.},
      "adult"= {data=ts5; target = adult~.},
    )
    
    # Creating the Model and making the predictions
    M = fit(target,data[H$tr,],model=model)
    Pred = predict(M,data[H$ts,])
    prev = data[H$tr,][,1]
    #print(prev)
    
    Pred = round(Pred)
    
    preds = c(selTS,Pred)
  
  res = list(
    preds=preds,
    prev = prev)
  
  print(res)
  return(res)
}

UniModel_Single = function(cen,week,model,selTS){
  # Load the Datasets
  loadData(cen)
  
  # Create Dataframe for Prediction Storage
  preds <- data.frame(matrix(ncol = 8, nrow = 0))
  # Name the Columns
  colnames(preds) <- c('ts','v1','v2','v3','v4','v5','v6','v7')
  
  residuals = c()

    switch(  
      selTS,  
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
    
    H = Holdout(week)
    print(H$tr)
    print(H$ts)
    
    if(model %in% models_forecast){
      dtr = ts(d1[H$tr],frequency=K)
      switch(  
        model,  
        "HW"= {M = suppressWarnings(HoltWinters(dtr))},
        "Arima"= {M = suppressWarnings(auto.arima(dtr))},
        "NN"= {M = suppressWarnings(nnetar(dtr,p=7))},
        "ETS"= {M = suppressWarnings(ets(dtr))},
      )  
      fcast <<- forecast(M,h=length(H$ts))
      Pred = fcast$mean[1:Test]
      Pred = round(Pred)
      preds = c(selTS, Pred)
    }else{
      timelags = c(1:7)
      D = CasesSeries(d1,timelags)
      
      M = fit(y~.,D[H$tr,],model=model)
      Pred = lforecast(M,D,start=(length(H$tr)+1),Test)
      Pred = round(Pred)
      preds = c(selTS, Pred)
    }
    prev = data[H$tr,][,1]
  
  #res = list(Preds = preds, fcast = fcast)
  res = list(
    preds=preds,
    prev=prev)
  
  print(res)
  return(res)
}

BestModel = function(week){
  #All
  res_all = HybridModel_Single("cen2",week,"HW","ctree","all")
  #Female
  res_female = HybridModel_Single("cen2",week,"ETS","ctree","female")
  #Male
  res_male = HybridModel_Single("cen2",week,"lm","lm","male")
  #Young
  res_young = HybridModel_Single("cen2",week,"lm","lm","young")
  #Adult
  res_adult = UniModel_Single("cen2",week,"HW","adult")
  
  res_preds <- data.frame(matrix(ncol = 8, nrow = 0))
  colnames(res_preds) <- c("ts", "v1","v2","v3","v4","v5","v6","v7")
  res_preds[1,] = c(res_all$preds)
  res_preds[2,] = c(res_female$preds)
  res_preds[3,] = c(res_male$preds)
  res_preds[4,] = c(res_young$preds)
  res_preds[5,] = c(res_adult$preds)
  
  res = list(
    preds=res_preds,
    all_prevs=res_all$prev,
    female_prevs=res_female$prev,
    male_prevs=res_male$prev,
    young_prevs=res_young$prev,
    adult_prevs=res_adult$prev)
  
  return(res)
  
}

# --------------------------------------------- Optimization -------------------------------------------------------

Optimization = function(opt_model,preds,obj){
  print("init optimizaion")
  createPreds(preds)
  switch(  
    opt_model,  
    "HillClimb"= {print("hillclimb"); res = hill(obj)},
    "MonteCarlo"= {print("mc"); res = montecarlo(obj)},
    "Tabu"= {print("tabu"); res = tabu(obj)},
    "Sann"= {print("sann"); res = sann(obj)},
    "RBGA" = {print("rgba"); res = rbgaFunction(obj)},
    "DeOptim" = {print("deoptim"); res = DEoptimFunction(obj)},
    "PsOptim" = {print("psoptim"); res = psoptimFunction(obj)}
  )
  return(res)
}


createForecastDataFrame = function(prev,preds){
  values = c(prev,preds)
  max_index = length(values)
  df = data.frame(index = c(1:max_index), values = values)
  res = list(df=df,max_index=max_index)
  return(res)
}







