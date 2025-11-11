library(shiny)
library(bslib)
library(plotly)
library(DT)
library(shinyWidgets)

ui <- fluidPage(
  theme = bs_theme(version = 5, bootswatch = 'sandstone'),
  titlePanel("Finance Dashboard - Kaggle data"),
  
  sidebarLayout(
    sidebarPanel(
      radioGroupButtons(
        inputId = "type_select",
        label = "Select transaction Type",
        choices = c("Expense", "Income"),
        selected = "Expense"
      ),
      
      selectInput(
        inputId = "category_select",
        label = "Select Expense Category",
        choices = NULL
      )
    ),
    
    mainPanel(
      layout_columns(
        col_widths = 4,
        value_box(title ="Total transactions", value = textOutput("total_transactions")),
        value_box(title ="Total Amount", value = textOutput("total_amount")),
        value_box(title ="Average amount", value = textOutput("avg_amount"))
      ),
      
      tabsetPanel(
        tabPanel("Plot", plotlyOutput(outputId = "expense_plot")),
        tabPanel("Table", DTOutput(outputId = "expense_table")),
        tabPanel("Comparison", plotlyOutput(outputId = "comparison_plot"))
      )
    )
  )
)