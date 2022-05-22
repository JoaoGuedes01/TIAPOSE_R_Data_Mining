library(shiny)
library(shinythemes)
library(bslib)

source("mlFunctions.R")

rminer <- c("lm","mlpe","naive","ctree","mlp","randomForest","mr","rvm","ksvm")
forecast <- c("HW","Arima","NN","ETS")

scenarios <- c("Scenario 1 (Untouched)","Scenario 2 (No outliers)","Scenario 3 (+ holidays)")
scenarios_list <- list("Scenario 1 (Untouched)"=1,"Scenario 2 (No outliers)"=2,"Scenario 3 (+ holidays)"=3)

opt_models <- c("HillClimb","MonteCarlo","Tabu","Sann")

objs <- c("Objetivo 1","Objetivo 2", "Objetivo 3")

models <- list("Hybrid Model"=1,"Univariate Model"=2,"Multivariate Model"=3)


ui <- fluidPage(theme = shinytheme("flatly"),
                navbarPage("TIAPOSE ML",
                           tabPanel("Predict",
                                    fluidPage(
                                      titlePanel("Forecast"),
                                      sidebarLayout(
                                        sidebarPanel(
                                          tabsetPanel(id="tabPages",
                                                      tabPanel("Best Solution",
                                                               h3("Prediction (Best Solution)"),
                                                               selectInput("week_best",h5("Week"),choices = weeks),
                                                               actionButton("predict_btn_best", label = "Run Model"),
                                                      ),
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
                                                       selectInput("pred_cb", label = h4("Predictions"), choices = timeSeries_list),
                                                       plotOutput("tsPred_plot")
                                                     )),
                                            tabPanel("Forecast", 
                                                     fluidRow(
                                                       tags$div(selectInput("forecast_cb",label = h4("Time Series"),choices = timeSeries_list),style="display:inline-block"),
                                                       tags$div(selectInput("forecast_cb_window",label = h4("Sample Size"),choices = c(30,50,100)),style="display:inline-block"),                    
                                                     ),
                                                     textOutput("forecast_plot_name"),
                                                     plotOutput("fcast_plot")),
                                          )
                                        )
                                      ),
                                    )),
                           tabPanel("Models",
                                    includeMarkdown("./markdown/models.md")
                                    ),
                           tabPanel("Data",
                                    dataTableOutput("all_data")),
                           tabPanel("EDA",
                                    tags$head(tags$style(HTML("
                                    .main-container {
                                    width: 100% !important;
                                    max-width: 100% !important;
                                 }

                               "))),
                                    includeCSS("./HTML/report.html")
                                    ),
                           tabPanel("Scenarios",
                                    includeMarkdown("./markdown/scenarios.md")),
                           tabPanel("Results",
                                    fluidPage(
                                      tags$div(selectInput("results_cen_cb",label = h4("Scenario"),choices = scenarios_list),style="display:inline-block"),
                                      tags$div(selectInput("results_model_cb",label = h4("Model"),choices = models),style="display:inline-block"),
                                      tags$div(selectInput("results_ts_cb",label = h4("Time Series"),choices = timeSeries_list),style="display:inline-block"),
                                      tags$div(actionButton("load_results_btn","Load Results"),style="display:inline-block"),
                                      dataTableOutput("results_data")
                                    ))
                ),
)

server = function(input,output,session){
  
  output$all_data <- renderDataTable(all_data)

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
    res_model = HybridModel(cen,week,uni_model,multi_model)
    preds <<- res_model$preds
    
    all_prevs <<- res_model$all_prevs
    female_prevs <<- res_model$female_prevs
    male_prevs <<- res_model$male_prevs
    young_prevs <<- res_model$young_prevs
    adult_prevs <<- res_model$adult_prevs
    
    res = Optimization(opt_model,preds)
    
    
    # Output
    output$ot_table = renderTable(res)
    output$pred_table = renderTable(preds)
    
    preds_all = as.numeric(unlist(preds[1,])[-1])
    plotPred(preds_all)
    plotForecast(all_prevs,preds_all)
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
    res_model = UnivariateModel(cen,uni_model,week)
    preds <<- res_model$preds
    
    all_prevs <<- res_model$all_prevs
    female_prevs <<- res_model$female_prevs
    male_prevs <<- res_model$male_prevs
    young_prevs <<- res_model$young_prevs
    adult_prevs <<- res_model$adult_prevs
    
    res = Optimization(opt_model,preds)
    
    
    # Output
    output$ot_table = renderTable(res)
    output$pred_table = renderTable(preds)
    
    preds_all = as.numeric(unlist(preds[1,])[-1])
    plotPred(preds_all)
    plotForecast(all_prevs,preds_all)
  },ignoreInit = TRUE)
  
  # Multivariate Model
  observeEvent(input$predict_btn_multi,{
    # Getting the variables 
    solutionType = "multi"
    multi_model = input$multimodel_multi
    opt_model = input$optmodel_multi
    obj_multi = input$obj_multi
    
    # Scenario value assignment 
    if(input$cen_multi == "Scenario 1 (Untouched)"){
      cen = "cen1"
    }else if(input$cen_multi == "Scenario 2 (No outliers)"){
      cen = "cen2"
    }else{
      cen = "cen3"
    }
    
    # Forecast
    res_model = MultivariateModel(cen,multi_model,week)
    preds <<- res_model$preds
    
    all_prevs <<- res_model$all_prevs
    female_prevs <<- res_model$female_prevs
    male_prevs <<- res_model$male_prevs
    young_prevs <<- res_model$young_prevs
    adult_prevs <<- res_model$adult_prevs
    
    res = Optimization(opt_model,preds)
    
    
    # Output
    output$ot_table = renderTable(res)
    output$pred_table = renderTable(preds)
    
    preds_all = as.numeric(unlist(preds[1,])[-1])
    plotPred(preds_all)
    plotForecast(all_prevs,preds_all)
  },ignoreInit = TRUE)
  
  
  # Best Solution (HW + lm)
  observeEvent(input$predict_btn_best,{
    # Getting the variables 
    solutionType = "hybrid"
    cen = "cen1"
    multi_model = "lm"
    uni_model = "HW"
    opt_model = "HillClimb"
    
    # Forecast
    res_model = HybridModel(cen,week,uni_model,multi_model)
    preds <<- res_model$preds
    
    all_prevs <<- res_model$all_prevs
    female_prevs <<- res_model$female_prevs
    male_prevs <<- res_model$male_prevs
    young_prevs <<- res_model$young_prevs
    adult_prevs <<- res_model$adult_prevs
    
    res = Optimization(opt_model,preds)
    
    
    # Output
    output$ot_table = renderTable(res)
    output$pred_table = renderTable(preds)
    
    preds_all = as.numeric(unlist(preds[1,])[-1])
    plotPred(preds_all)
    plotForecast(all_prevs,preds_all)
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
  
  # Best Tab
  observeEvent(input$week_best,{
    week <<- getWeek(as.numeric(input$week_best))
    print(week)
  })
  
  
  
  observeEvent(input$forecast_cb,{
    preds = as.numeric(unlist(preds[input$forecast_cb,])[-1])
    currentTS = input$forecast_cb
    switch(  
      currentTS,  
      "1"= {prevs = all_prevs},
      "2"= {prevs = female_prevs},
      "3"= {prevs = male_prevs},
      "4"= {prevs = young_prevs},
      "5"= {prevs = adult_prevs},
    )
    print(prevs)
    print(preds)
    plotForecast(prevs,preds)

  },ignoreInit = TRUE)
  
  observeEvent(input$pred_cb,{
    preds = as.numeric(unlist(preds[input$pred_cb,])[-1])
    plotPred(preds)
    
  },ignoreInit = TRUE)
  
  observeEvent(input$results_cen_cb,{
    print(input$results_model_cb)
    switch(
      input$results_cen_cb,
      "1"= {results_cen <<- "Cenario 1"},
      "2"= {results_cen <<- "Cenario 2"},
      "3"= {results_cen <<- "Cenario 3"}
    )
    #loadResults(as.numeric(results_cen), results_model ,as.numeric(input$results_ts_cb))
  })
  
  observeEvent(input$results_model_cb,{
    print(input$results_model_cb)
    switch(  
      input$results_model_cb,  
      "1"= {results_model <<- "Modelos Hibridos"},
      "2"= {results_model <<- "Modelos Multivariados"},
      "3"= {results_model <<- "Modelos Univariados"}
    )
    #loadResults(as.numeric(results_cen), results_model ,as.numeric(input$results_ts_cb))
  })
  
  # observeEvent(input$results_ts_cb,{
  #   loadResults(as.numeric(results_cen), results_model ,as.numeric(input$results_ts_cb))
  # },ignoreInit = TRUE)
  
  observeEvent(input$load_results_btn,{
    results_data = loadResults(results_cen, results_model ,as.numeric(input$results_ts_cb))
    output$results_data <- renderDataTable(results_data)
  },ignoreInit = TRUE)
  
  
  
  
  
  # Plotting Functions 
  
  plotPred = function(preds){
    output$tsPred_plot = renderPlot({
      barplot(
        preds,
        names = c(1:7)
      )
    })
  }
  
  
  plotForecast = function(prev,pred){
    output$fcast_plot = renderPlot({
      res_createDF = createForecastDataFrame(prev,pred)
      fcastDF = res_createDF$df
      max_index = res_createDF$max_index
      fcastDF$highlight <- ifelse(fcastDF$values %in% pred, "blue", "black")
      window_size = as.numeric(input$forecast_cb_window)
      length_ultimos = (max_index - window_size):max_index
      ggplot(fcastDF[length_ultimos,], aes(x = index, y = values, colour = highlight, group = 1)) +
        geom_line() +
        scale_colour_identity(pred)
    })
  }
}

shinyApp(ui,server)