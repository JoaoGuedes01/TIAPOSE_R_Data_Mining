source("serverController.R")

#* @param firsDay
#* @param lastDay
#* @get /predict
function(firsDay,lastDay){
  
  # Using the HybridModel to get the predictions for all Time Series
  preds = HybridModel(firsDay,lastDay) # 101 - 107
  
  # Using the predictions in the HillClimbing function to get estimates for each day
  res = hillClimbing(preds)
  return(res)
}


#* @get /
function(){
  
  page = "./vue_build/index.html"
  return(page)
}