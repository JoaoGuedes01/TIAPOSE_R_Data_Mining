library(shiny)
source("mlFunctions.R")

# UI
ui = fluidPage(
  mainPanel(
    # Text Input for 1st day
    textInput(inputId = "fd", 
              label = "First Day", 
              value = "", 
              placeholder = "First Day"
    ),
    # Text Input for last day
    textInput(inputId = "ld", 
              label = "Last Day", 
              value = "", 
              placeholder = "Last Day"
    ),
    actionButton("pred", "Predict"),
    fluidRow(
      column(
        tableOutput(outputId = "preds"),width=6)
    ),
    textOutput("res")
  )
  
  
  
  )
   
# I/O function            
server = function(input,output){
  observeEvent(input$pred,{
    firsDay = input$fd
    lastDay = input$ld
    preds = HybridModel(firsDay,lastDay) # 101 - 107
    output$preds = renderTable(
      {preds},
      options = list(scrollX = TRUE))
    
    res = hillClimbing(preds)
    output$res = renderText({res})
  })
}


# Server
shinyApp(ui,server)