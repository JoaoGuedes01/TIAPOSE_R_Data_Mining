library(shiny)
library(shiny.fluent)

ui <- fluentPage(
  navbarPage("GuedesML",
             tabPanel("Predict",
                      dateInput(
                        inputId ="dateID",
                        label = "Data",
                        format = "yyyy-mm-dd",
                        startview = "decade",
                        value = NULL,
                        min = "2013-04-09",
                        max = "2013-12-15"
                      ),
                      textOutput("weekRange"),
                      actionButton("predict","Predict"),
                      fluidRow(
                        column(
                          tableOutput(outputId = "preds"),width=6)
                      ),
                      textOutput("ts1"),
                      textOutput("ts2"),
                      textOutput("ts3"),
                      textOutput("ts4"),
                      textOutput("ts5")
             ),
             tabPanel("Models"),
             tabPanel("EDA"),
             tabPanel("Scenarios"))
)

server <- function(input,output){
  
}

shinyApp(ui,server)
