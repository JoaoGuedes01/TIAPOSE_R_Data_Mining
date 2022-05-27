library(shiny)
library(shinythemes)
library(bslib)

source("mlFunctions.R")

rminer <- c("lm","mlpe","naive","ctree","mlp","randomForest","mr","rvm","ksvm")
forecast <- c("HW","Arima","NN","ETS")

scenarios <- c("Scenario 1 (Untouched)","Scenario 2 (No outliers)","Scenario 3 (+ holidays)")
scenarios_list <- list("Scenario 1 (Untouched)"=1,"Scenario 2 (No outliers)"=2,"Scenario 3 (+ holidays)"=3)

opt_models <- c("HillClimb","MonteCarlo","Tabu","Sann","RBGA","DeOptim","PsOptim")

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
                                                               selectInput("obj_best",label = h4("Optimization Objective"), choices = objs),
                                                               actionButton("predict_btn_best", label = "Run Model"),
                                                               actionButton("showHelpModal", label = icon("question"), style="background-color:#00b4d8; border-color:#00b4d8"),
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
                                                               actionButton("predict_btn_hybrid", label = "Run Model"),
                                                               actionButton("showHelpModal_hybrid", label = icon("question"), style="background-color:#00b4d8; border-color:#00b4d8"),
                                                               
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
                                                               actionButton("predict_btn_uni", label = "Run Model"),
                                                               actionButton("showHelpModal_uni", label = icon("question"), style="background-color:#00b4d8; border-color:#00b4d8"),
                                                               
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
                                                               actionButton("showHelpModal_multi", label = icon("question"), style="background-color:#00b4d8; border-color:#00b4d8"),
                                                               
                                                      )
                                          ),
                                        ),
                                        mainPanel(
                                          tabsetPanel(
                                            tabPanel("Otimization", 
                                                     h3(textOutput("all_opt_label")),
                                                     uiOutput("ot_table_all"),
                                                     h3(textOutput("female_opt_label")),
                                                     uiOutput("ot_table_female"),
                                                     h3(textOutput("male_opt_label")),
                                                     uiOutput("ot_table_male"),
                                                     h3(textOutput("young_opt_label")),
                                                     uiOutput("ot_table_young"),
                                                     h3(textOutput("adult_opt_label")),
                                                     uiOutput("ot_table_adult"),
                                                     h3(textOutput("opt_total_profit")),
                                                     ),
                                            tabPanel("Predictions", 
                                                     fluidPage(
                                                       uiOutput("pred_table"),
                                                       selectInput("pred_cb", label = h4("Predictions"), choices = timeSeries_list),
                                                       plotOutput("tsPred_plot")
                                                     )),
                                            tabPanel("Forecast", 
                                                     fluidRow(
                                                       tags$div(selectInput("forecast_cb",label = h4("Time Series"),choices = timeSeries_list),style="display:inline-block"),
                                                       tags$div(selectInput("forecast_cb_window",label = h4("Window Size"),choices = c(30,50,100)),style="display:inline-block"),                    
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
                                    )),
                           tabPanel("Best Models",
                                    includeMarkdown("./markdown/best_models.md")
                                    )
                ),
)

server = function(input,output,session){
  
  
  
  observeEvent(input$showHelpModal_hybrid, {
    showHelpModal()
  })
  observeEvent(input$showHelpModal_uni, {
    showHelpModal()
  })
  observeEvent(input$showHelpModal_multi, {
    showHelpModal()
  })
  
  observeEvent(input$showHelpModal, {
    showHelpModal()
  })
  
  showHelpModal = function(){
    showModal(modalDialog(
      title = "Information",
      fluidPage(
        h2("Why are the weeks starting at Week 6?"),
        h5("In order for us to train our models properly we need to have some data (i.e weeks 1-5) reserved to be train data"),
        h2("What are de Optimization Objectives?"),
        h3("Objective 1"),
        h5("This Objective aims to get the highest profit disregarding the number of marketing campaigns ran."),
        h3("Objective 2"),
        h5("This objective aims to get the highest profit under 10 marketing campaigns across all types(Time Series) and days of the selected week."),
        h3("Objective 3"),
        h5("This objective aims to maximize the profits while having the lowest number of campaigns possible."),
        h2("What is our best solution?"),
        h4("Our best solution is divided into the 5 time series that are available"),
        h5("(These models are backed up by our model results in the Results tab)"),
        h3("All"),
        h4("Hybrid Model: Holt Winters + ctree"),
        h3("Female"),
        h4("Hybrid Model: ETS + ctree"),
        h3("Male"),
        h4("Hybrid Model: lm + lm"),
        h3("Young"),
        h4("Hybrid Model: lm + lm"),
        h3("Adult"),
        h4("Univariate Model: Holt Winters"),
        h3("Scenario"),
        h4("Scenario 2"),
        h5("With the Scenario 2's data we've had the best values for MAE/NMAE with all of our models"),
        h3("Optimization Model"),
        h4("Tabu"),
        h5("All of the optimization models return great values but the best one, in our tests, was Tabu"),
      ),
      easyClose = TRUE
    ))
  }
  
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
    obj_hybrid = input$obj_hybrid
    
    
    
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
    
    res = Optimization(opt_model,preds,obj_hybrid)
    
    
    #Output
    
    # Output Otimization All
    output$ot_table_all = renderTable(createOptTableDF(res,"all"))
    output$ot_table_female = renderTable(createOptTableDF(res,"female"))
    output$ot_table_male = renderTable(createOptTableDF(res,"male"))
    output$ot_table_young = renderTable(createOptTableDF(res,"young"))
    output$ot_table_adult = renderTable(createOptTableDF(res,"adult"))
    
    output$opt_total_profit = renderText(paste("Total Profit for the week:",res$total_profit,"€"))
    
    populateTableTitlesOpt()
    
    colnames(preds) = c("Time Series", getWeekDays(week))
    print(preds)
    
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
    obj_uni = input$obj_uni
    
    
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
    
    res = Optimization(opt_model,preds,obj_uni)
    
    
    #Output
    
    # Output Otimization All
    output$ot_table_all = renderTable(createOptTableDF(res,"all"))
    output$ot_table_female = renderTable(createOptTableDF(res,"female"))
    output$ot_table_male = renderTable(createOptTableDF(res,"male"))
    output$ot_table_young = renderTable(createOptTableDF(res,"young"))
    output$ot_table_adult = renderTable(createOptTableDF(res,"adult"))
    
    output$opt_total_profit = renderText(paste("Total Profit for the week:",res$total_profit,"€"))
    
    
    
    populateTableTitlesOpt()
    
    colnames(preds) = c("Time Series", getWeekDays(week))
    print(preds)
    
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
    print(obj_multi)
    
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
    
    res = Optimization(opt_model,preds,obj_multi)
    
    #Output
    
    # Output Otimization All
    output$ot_table_all = renderTable(createOptTableDF(res,"all"))
    output$ot_table_female = renderTable(createOptTableDF(res,"female"))
    output$ot_table_male = renderTable(createOptTableDF(res,"male"))
    output$ot_table_young = renderTable(createOptTableDF(res,"young"))
    output$ot_table_adult = renderTable(createOptTableDF(res,"adult"))
    
    output$opt_total_profit = renderText(paste("Total Profit for the week:",res$total_profit,"€"))
    
    populateTableTitlesOpt()
    
    colnames(preds) = c("Time Series", getWeekDays(week))
    print(preds)
    
    output$pred_table = renderTable(preds)
    
    preds_all = as.numeric(unlist(preds[1,])[-1])
    plotPred(preds_all)
    plotForecast(all_prevs,preds_all)
  },ignoreInit = TRUE)
  
  populateTableTitlesOpt = function(){
    output$all_opt_label = renderText("All")
    output$female_opt_label = renderText("Female")
    output$male_opt_label = renderText("Male")
    output$young_opt_label = renderText("Young")
    output$adult_opt_label = renderText("Adult")
  }
  
  createOptTableDF = function(res_list,ts){
    
    res = res_list
    df <- data.frame(matrix(ncol = 8, nrow = 0))
    colnames(df) <- c("Value", getWeekDays(week))
    
    sol_proc <- ifelse(res$sols_res[[ts]]==0, "No", "Yes")
    df[1,] = c("Solution",sol_proc)

    df[2,] = c("Sales",res$sales_res[[ts]])
    df[3,] = c("Cost",res$cost_res[[ts]])
    df[4,] = c("Profit",res$profit_res[[ts]])

    return(df)
  }
  
  
  # Best Solution (HW + lm)
  observeEvent(input$predict_btn_best,{
    # Getting the variables 
    solutionType = "hybrid"
    cen = "cen1"
    multi_model = "lm"
    uni_model = "HW"
    opt_model = "Tabu"
    #opt_model = "HillClimb"
    obj_best= input$obj_best
    
    # Forecast
    res_model = BestModel(week)
    preds <<- res_model$preds
    
    all_prevs <<- res_model$all_prevs
    female_prevs <<- res_model$female_prevs
    male_prevs <<- res_model$male_prevs
    young_prevs <<- res_model$young_prevs
    adult_prevs <<- res_model$adult_prevs
    
    res = Optimization(opt_model,preds,obj_best)
    
    #Output
    
    # Output Otimization All
    output$ot_table_all = renderTable(createOptTableDF(res,"all"))
    output$ot_table_female = renderTable(createOptTableDF(res,"female"))
    output$ot_table_male = renderTable(createOptTableDF(res,"male"))
    output$ot_table_young = renderTable(createOptTableDF(res,"young"))
    output$ot_table_adult = renderTable(createOptTableDF(res,"adult"))
    
    output$opt_total_profit = renderText(paste("Total Profit for the week:",res$total_profit,"€"))
    
    populateTableTitlesOpt()
    
    colnames(preds) = c("Time Series", getWeekDays(week))
    print(preds)
    
    # Output
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
        names = getWeekDays(week)
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