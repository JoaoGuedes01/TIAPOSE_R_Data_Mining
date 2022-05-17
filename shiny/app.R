library(shiny)
library(shinythemes)
library(bslib)

source("mlFunctions.R")

rminer <- c("lm","mlpe","naive","ctree","mlp","randomForest","mr","rvm","ksvm")
forecast <- c("HW","Arima","NN","ETS")

listaopt <- c("opt1","opt2","opt3")

scenarios <- c("Scenario 1 (Untouched)","Scenario 2 (No outliers)","Scenario 3 (+ holidays)")


ui <- fluidPage(theme = shinytheme("flatly"),
                navbarPage("TIAPOSE ML",
                           tabPanel("Predict",
                                    fluidPage(
                                      titlePanel("Forecast"),
                                      sidebarLayout(
                                        sidebarPanel(
                                          tabsetPanel(id="tabPages",
                                                      tabPanel("Hybrid",
                                                               h3("Prediction (Hybrid Modeling)"),
                                                               selectInput("cen_hybrid",h5("Scenario"),choices = scenarios),
                                                               h4("Univariate Models"),
                                                               radioButtons("radio_uni_hybrid", label = h5("Forecasting Pacakge"),choices = list("Forecast" = 1, "Rminer" = 2) ,selected = 1),
                                                               selectInput("unimodel_hybrid","package",choices = c(),selected = 1),
                                                               br(),
                                                               h4("Multivariate Models"),
                                                               selectInput("multimodel_hybrid","(Rminer)",choices = rminer),
                                                               br(),
                                                               h3("Optimization"),
                                                               selectInput("optmodel_hybrid",label = h4("Optimization Model"),choices = listaopt),
                                                               actionButton("predict_btn_hybrid", label = "Run Model")
                                                      ),
                                                      tabPanel("Univariate",
                                                               h3("Prediction (Univariate Modeling)"),
                                                               selectInput("cen_uni",h5("Scenario"),choices = scenarios),
                                                               h4("Univariate Models"),
                                                               radioButtons("radio_uni_uni", label = h5("Forecasting Pacakge"),choices = list("Forecast" = 1, "Rminer" = 2) ,selected = 1),
                                                               selectInput("unimodel_uni","package",choices = c(), selected = 1),
                                                               br(),
                                                               h3("Optimization"),
                                                               selectInput("optmodel_uni",label = h4("Optimization Model"),choices = listaopt),
                                                               actionButton("predict_btn_uni", label = "Run Model")
                                                      ),
                                                      tabPanel("Multivariate",
                                                               h3("Prediction (Multivariate Modeling)"),
                                                               selectInput("cen_multi",h5("Scenario"),choices = scenarios),
                                                               h4("Multivariate Models"),
                                                               selectInput("multimodel_multi","(Rminer)",choices = rminer),
                                                               br(),
                                                               h3("Optimization"),
                                                               selectInput("optmodel_multi",label = h4("Optimization Model"),choices = listaopt),
                                                               actionButton("predict_btn_multi", label = "Run Model")
                                                      )
                                          ),
                                        ),
                                        mainPanel(
                                          verbatimTextOutput("res")
                                        )
                                      ),
                                    )),
                           tabPanel("Models"),
                           tabPanel("Data"),
                           tabPanel("Scenarios")
                ),
)

server = function(input,output,session){

  # Update Model Lists based on Package Choice
  
  # Hybrid Model
  observeEvent(input$radio_uni_hybrid,{
    if(input$radio_uni_hybrid == 1){
      updateSelectInput(session, "unimodel_hybrid", "(Forecast)", forecast)
    }else {
      updateSelectInput(session, "unimodel_hybrid", "(Rminer)", rminer)
    }
  })
  
  # Univariate Model
  observeEvent(input$radio_uni_uni,{
    if(input$radio_uni_uni == 1){
      updateSelectInput(session, "unimodel_uni", "(Forecast)", forecast)
    }else {
      updateSelectInput(session, "unimodel_uni", "(Rminer)", rminer)
    }
  })
  
  
  # Get input data
  
  # Hybrid Model
  observeEvent(input$predict_btn_hybrid,{
    # alocating variables 
    solutionType = "hybrid"
    cen = input$cen_hybrid
    multi_model = input$multimodel_hybrid
    uni_model = input$unimodel_hybrid
    opt_model = input$optmodel_hybrid
    
    cona = list(solutionType,cen,multi_model,uni_model,opt_model)
    output$res <- renderPrint({cona})
    
    print(cona)
  },ignoreInit = TRUE)
  
  # Univariate Model
  observeEvent(input$predict_btn_uni,{
    # alocating variables 
    solutionType = "uni"
    cen = input$cen_uni
    uni_model = input$unimodel_uni
    opt_model = input$optmodel_uni
    
    if(input$cen_multi == "Scenario 1 (Untouched)"){
      cen = "cen1"
    }else if(input$cen_multi == "Scenario 2 (No outliers)"){
      cen = "cen2"
    }else{
      cen = "cen3"
    }
    
    # test day
    week = c(36:42)
    preds = UnivariateModel(cen,uni_model,week)
  },ignoreInit = TRUE)
  
  # Multivariate Model
  observeEvent(input$predict_btn_multi,{
    # alocating variables 
    solutionType = "multi"
    multi_model = input$multimodel_multi
    opt_model = input$optmodel_multi
    
    if(input$cen_multi == "Scenario 1 (Untouched)"){
      cen = "cen1"
    }else if(input$cen_multi == "Scenario 2 (No outliers)"){
      cen = "cen2"
    }else{
      cen = "cen3"
    }
    
    # test day
    day = "2013-05-14"
    preds = MultivariateModel(cen,multi_model,day)
  },ignoreInit = TRUE)
}

shinyApp(ui,server)


