library(shiny)
library(tidyverse)
library(plotly)
library(DT)
library(bslib)
library(scales)
library(lubridate)

finance_data <- read.csv('Data/Personal_Finance_Dataset.csv')
glimpse(finance_data) # For columns names visualization

income_categories <- finance_data %>%
  filter(Type == "Income") %>%
  pull(Category) %>%
  unique()

expense_categories <- finance_data %>%
  filter(Type == "Expense") %>%
  pull(Category) %>%
  unique()



server <- function(input, output, session){
  observeEvent(input$type_select, {
    
    categories_to_use <- if (input$type_select == "Income") {
      income_categories
    } else {
      expense_categories
    }
    
    updateSelectInput(
      session = session,
      inputId = "category_select",
      choices = categories_to_use
    )
  }, ignoreInit = FALSE)
  
  reactive_data <- reactive({
    req(input$type_select, input$category_select)
    
    finance_data %>%
      filter(
        Type == input$type_select,
        Category == input$category_select
      )
  })
  
  output$total_transactions <- renderText({
    df <- reactive_data()
    nrow(df)
  })
  output$total_amount <- renderText({
    df <- reactive_data()
    dollar(sum(df$Amount), accuracy = 0.01)
    })
  output$avg_amount <- renderText({
    df <- reactive_data()
    dollar(mean(df$Amount), accuracy = 0.01)
  })
  
  output$expense_plot <- renderPlotly({
    df <- reactive_data()
    
    plot_ly(df, x = ~Date, y = ~Amount, type = "bar",
            text = ~Transaction.Description,
            hoverinfo = 'text+y+x') %>%
      layout(
        title = paste("Transactions for", input$category_select),
        xaxis = list(title = "Date"),
        yaxis = list(title = "Amount"),
        colorway = c("#636EFA")
      )
  })
  
  output$expense_table <- renderDT({
    df <- reactive_data()
    
    datatable(
      df,
      options = list(pageLength = 10),
      rownames = FALSE,
      class = 'cell-border stripe'
    )
  })
  
  comparison_data <- reactive({
    finance_data %>%
    mutate(Date = as.Date(Date)) %>%
    mutate(Month = lubridate::floor_date(Date, unit = 'month')) %>%
    group_by(Month, Type) %>%
      summarize(Total = sum(Amount), .groups = "drop")
  })
  
  output$comparison_plot <- renderPlotly({
    df <- comparison_data()
    
    plot_ly(df, x = ~Month, y = ~Total, type = "scatter",
            mode = 'lines', color = ~Type) %>%
    layout(
      title = paste("Comparison of income and expenses"),
      xaxis = list(title = "Month"),
      yaxis = list(title = "Total")
    )
  })
  
}














