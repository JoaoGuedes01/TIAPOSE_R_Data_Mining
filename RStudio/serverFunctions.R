source("serverFunc.R")

#* @param week
#* @get /predict
function(week){
  # 1_2_3_4_5_6_7
  cona = predict(week)
  # res=paste("You are Predicting values for: ",week,sep = "")
  #res = c(tr,ts)
  #print(res)
  return(cona)
}