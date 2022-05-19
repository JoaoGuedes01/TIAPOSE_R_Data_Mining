library(shiny)
library(shinythemes)
library(bslib)

source("mlFunctions.R")

rminer <- c("lm","mlpe","naive","ctree","mlp","randomForest","mr","rvm","ksvm")
forecast <- c("HW","Arima","NN","ETS")

scenarios <- c("Scenario 1 (Untouched)","Scenario 2 (No outliers)","Scenario 3 (+ holidays)")

opt_models <- c("HillClimb","MonteCarlo","Tabu","Sann")

objs <- c("Objetivo 1","Objetivo 2", "Objetivo 3")


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
                                                               selectInput("week_hybrid",h5("Week"),choices = weeks),
                                                               selectInput("cen_hybrid",h5("Scenario"),choices = scenarios),
                                                               h4("Univariate Models"),
                                                               radioButtons("radio_uni_hybrid", label = h5("Forecasting Pacakge"),choices = list("Forecast" = 1, "Rminer" = 2) ,selected = 1),
                                                               selectInput("unimodel_hybrid","package",choices = c(),selected = 1),
                                                               br(),
                                                               h4("Multivariate Models"),
                                                               selectInput("multimodel_hybrid","(Rminer)",choices = rminer),
                                                               br(),
                                                               h3("Optimization"),
                                                               selectInput("optmodel_hybrid",label = h4("Optimization Model"),choices = opt_models),
                                                               selectInput("obj_hybrid",label = h4("Objetivo de Otimização"), choices = objs),
                                                               actionButton("predict_btn_hybrid", label = "Run Model")
                                                      ),
                                                      tabPanel("Univariate",
                                                               h3("Prediction (Univariate Modeling)"),
                                                               selectInput("week_uni",h5("Week"),choices = weeks),
                                                               selectInput("cen_uni",h5("Scenario"),choices = scenarios),
                                                               h4("Univariate Models"),
                                                               radioButtons("radio_uni_uni", label = h5("Forecasting Pacakge"),choices = list("Forecast" = 1, "Rminer" = 2) ,selected = 1),
                                                               selectInput("unimodel_uni","package",choices = c(), selected = 1),
                                                               br(),
                                                               h3("Optimization"),
                                                               selectInput("optmodel_uni",label = h4("Optimization Model"),choices = opt_models),
                                                               selectInput("obj_uni",label = h4("Objetivo de Otimização"), choices = objs),
                                                               actionButton("predict_btn_uni", label = "Run Model")
                                                      ),
                                                      tabPanel("Multivariate",
                                                               h3("Prediction (Multivariate Modeling)"),
                                                               selectInput("week_multi",h5("Week"),choices = weeks),
                                                               selectInput("cen_multi",h5("Scenario"),choices = scenarios),
                                                               h4("Multivariate Models"),
                                                               selectInput("multimodel_multi","(Rminer)",choices = rminer),
                                                               br(),
                                                               h3("Optimization"),
                                                               selectInput("optmodel_multi",label = h4("Optimization Model"),choices = opt_models),
                                                               selectInput("obj_multi",label = h4("Objetivo de Otimização"), choices = objs),
                                                               actionButton("predict_btn_multi", label = "Run Model"),
                                                      )
                                          ),
                                        ),
                                        mainPanel(
                                          tabsetPanel(
                                            tabPanel("Otimization", 
                                                     uiOutput("ot_table")),
                                            tabPanel("Predictions", 
                                                     fluidPage(
                                                       uiOutput("pred_table"),
                                                       plotOutput("tsPred_plot")
                                                     )),
                                            tabPanel("Forecast", 
                                                     plotOutput("res_plot")),
                                          )
                                        )
                                      ),
                                    )),
                           tabPanel("Models",
                                    includeMarkdown("./markdown/teste.md")
                                    ),
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
  
  
  # Predict Button
  
  # Hybrid Model
  observeEvent(input$predict_btn_hybrid,{
    # Getting the variables 
    solutionType = "hybrid"
    cen = input$cen_hybrid
    multi_model = input$multimodel_hybrid
    uni_model = input$unimodel_hybrid
    opt_model = input$optmodel_hybrid
    
    
    # Scenario value assignment
    if(input$cen_multi == "Scenario 1 (Untouched)"){
      cen = "cen1"
    }else if(input$cen_multi == "Scenario 2 (No outliers)"){
      cen = "cen2"
    }else{
      cen = "cen3"
    }
    
    # Forecast
    preds = HybridModel(cen,week,uni_model,multi_model)
    res = hillClimbing(preds)
    
    # Output
    output$ot_table = renderTable(res)
    output$pred_table = renderTable(preds)
    output$tsPred_plot = renderPlot({
      barplot(
        as.numeric(preds[1,][2:8]),
        names = c("D","S","T","Q","Q","S","S")
      )
    })
  },ignoreInit = TRUE)
  
  # Univariate Model
  observeEvent(input$predict_btn_uni,{
    # Getting the variables 
    solutionType = "uni"
    cen = input$cen_uni
    uni_model = input$unimodel_uni
    opt_model = input$optmodel_uni
    
    
    # Scenario value assignment 
    if(input$cen_multi == "Scenario 1 (Untouched)"){
      cen = "cen1"
    }else if(input$cen_multi == "Scenario 2 (No outliers)"){
      cen = "cen2"
    }else{
      cen = "cen3"
    }
    
    # Forecast
    preds = UnivariateModel(cen,uni_model,week)
    res = hillClimbing(preds)
    
    # Output
    output$ot_table = renderTable(res)
    output$pred_table = renderTable(preds)
    output$tsPred_plot = renderPlot({
      barplot(
        as.numeric(preds[1,][2:8]),
        names = c("D","S","T","Q","Q","S","S")
        )
    })
    output$res_plot = renderPlot({residual_plot})
  },ignoreInit = TRUE)
  
  # Multivariate Model
  observeEvent(input$predict_btn_multi,{
    # Getting the variables 
    solutionType = "multi"
    multi_model = input$multimodel_multi
    opt_model = input$optmodel_multi
    
    # Scenario value assignment 
    if(input$cen_multi == "Scenario 1 (Untouched)"){
      cen = "cen1"
    }else if(input$cen_multi == "Scenario 2 (No outliers)"){
      cen = "cen2"
    }else{
      cen = "cen3"
    }
    
    # Forecast
    preds = MultivariateModel(cen,multi_model,week)
    res = hillClimbing(preds)
    
    # Output
    output$ot_table = renderTable(res)
    output$pred_table = renderTable(preds)
    output$tsPred_plot = renderPlot({
      barplot(
        as.numeric(preds[1,][2:8]),
        names = c("D","S","T","Q","Q","S","S")
      )
    })
  },ignoreInit = TRUE)
  
  output$models_markdown <- renderUI({
    HTML(markdown::markdownToHTML(knit('./markdown/models.rmd', quiet = TRUE)))
  })
  
  
  # Get Selected Week
  
  # Hybrid Tab
  observeEvent(input$week_hybrid,{
    week <<- getWeek(as.numeric(input$week_hybrid))
    print(week)
  })
  
  # Univaraite Tab
  observeEvent(input$week_uni,{
    week <<- getWeek(as.numeric(input$week_uni))
    print(week)
  })
  
  # Multivariate Tab
  observeEvent(input$week_multi,{
    week <<- getWeek(as.numeric(input$week_multi))
    print(week)
  })
}

shinyApp(ui,server)