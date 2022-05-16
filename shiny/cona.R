library(shiny)

myData <- read.table(text = "   A            B
           Interest         7
           Interest         2
           Demographics     3
           Travel           4
           Financial        4
           Lifestyle        6
           Lifestyle        7
           Technology       9", header = TRUE, stringsAsFactors = FALSE)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(checkboxGroupInput("cats",
                                    label = "Which category would you like to see?",
                                    choices = unique(myData$A),
                                    selected = unique(myData$A))),
    mainPanel(dataTableOutput("table"))
  )
)

server <- function(input, output) {
  
  output$table <- renderDataTable({
    subset(myData, A %in% input$cats, select = "B")
  })
}

shinyApp(ui, server)