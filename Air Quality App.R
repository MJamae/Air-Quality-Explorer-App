install.packages("shiny")
install.packages("tidyverse")
install.packages("ggplot2")
install.packages("DT")


# Load required libraries
library(shiny)
library(ggplot2)
library(DT)

#User Interface (UI)
ui <- fluidPage(
  titlePanel("Air Quality Data Explorer"),
  sidebarLayout(
    sidebarPanel(
      selectInput("month", "Select a Month:", choices = unique(airquality$Month)),
      selectInput("column", "Select a Column to Plot:", choices = c("Wind" = "Wind", "Temperature" = "Temp"))
    ),
    mainPanel(
      dataTableOutput("data_table"),
      plotOutput("plot")
    )
  )
)

# Server Logic
server <- function(input, output) {
  filtered_data <- reactive({
    data <- airquality
    data <- subset(data, Month == input$month)
    data
  })
  
  output$data_table <- renderDataTable({
    filtered_data()
  })
  
  output$plot <- renderPlot({
    ggplot(filtered_data(), aes_string(x = "Day", y = input$column)) +
      geom_point() +
      geom_line() +
      labs(x = "Day", y = input$column)
  })
}

shinyApp(ui = ui, server = server)



