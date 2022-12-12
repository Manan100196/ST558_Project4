library(shiny)
library(shinydashboard)

#About
"The app provides information regarding the source data. Based on the data, exploratory data
analysis plots will be created as per the variables and plot type
selected by the user. The app also has a modelling page which has information regarding how each
models fits and train the data. Finally, the app will also display the predicted value of testing
dataset"

#Discussion of data and its source
"The dataset is obtained from kaggle. The url is
https://www.kaggle.com/datasets/prathamtripathi/regression-with-neural-networking
The dataset provides details of the individual elements present in the mixture of cement. The goal
is to predict the strength of concrete produced. More the strength, better it is for the
construction company."

#

#data <- read.csv("/Users/mjiwtan/Downloads/concrete_data.csv")

# Define UI for application that draws a histogram
# shinyUI(fluidPage(
# 
#     # Application title
#     titlePanel("Old Faithful Geyser Data"),
# 
#     # Sidebar with a slider input for number of bins
#     sidebarLayout(
#         sidebarPanel(
#             sliderInput("bins",
#                         "Number of bins:",
#                         min = 1,
#                         max = 50,
#                         value = 30)
#         ),
# 
#         # Show a plot of the generated distribution
#         mainPanel(
#             plotOutput("distPlot")
#         )
#     )
# ))
dashboardPage(
  dashboardHeader(title = "Concrete Strength", titleWidth = 600),
  
  dashboardSidebar(sidebarMenu(
    menuItem("About", tabName = "about", icon = icon("archive")),
    menuItem("Data Exploration",tabName="eda",icon=icon("bar-chart")),
    menuItem("Modeling",tabName = "model",icon=icon("table")),
    menuItem("Data",tabName="data",icon=icon("list-alt"))
    )),
    
    dashboardBody(
      tabItems(
        tabItem(tabName = "about",
          fluidRow(
            column(6,h1("App Information"),
                   box(width=NULL,background="red",
                  h4("The app provides information regarding the source data. Based on the data, 
                  exploratory data analysis plots will be created as per the variables and plot 
                  type selected by the user. The app also has a modelling page which has 
                  information regarding how each models fits and train the data. Finally, the 
                  app will also display the predicted value of testing dataset"))
                   ),
            column(6,h1("Discussion of data"),
                   box(width=NULL,background="red",
                  h4("The dataset is obtained from kaggle. The url is https://www.kaggle.com/datasets/prathamtripathi/regression-with-neural-networking
The dataset provides details of the individual elements present in the mixture of cement. The goal
is to predict the strength of concrete produced. More the strength, better it is for the
construction company."))
            )
          ),
        fluidRow(
          column(12,h1("Purpose of each page"),
                 box(width=NULL,height=45,background="red",
                h4("Purpose")
          )
        )
        ),
        fluidRow(
          column(12,h1("Image"),
                 box(width=NULL,height=45,background="red",
                        h4("Image")
          )
          )
        )
      ),
    tabItem(tabName = "eda",
      fluidRow(
        column(4,
          box(width = 15,background = "red", height = 250, title = "Contingency Table",
              selectizeInput("cont_var", "Contigency Variable", selected = "water", 
                             choices = levels(as.factor(c("water", "cement")))))),
          column(8, 
                 box(width=NULL,height = 250, title="Contingency Table",tableOutput("table_contingency"))
          )),
          br(),
      fluidRow(
        column(4,
          box(width = 15, background = "red", height = 450, title = "Type of Plots",
                   selectizeInput("plot1", "Plot 1", selected = "Bar Plot", 
                                  choices = levels(as.factor(c("Bar Graph", "Line Graph")))),
                   selectizeInput("plot2", "Plot 2", selected = "Scatter Plot", 
                                  choices = levels(as.factor(c("Scatter Plot", "Correlation Plot"))))
               )
                      ),
        column(8,
          box(width = NULL, height = 450, title = "PLOT 1", plotOutput("plot_1"))
               )),
          br(),
      fluidRow(
        column(4,
          box(width = 15, background = "red", height = 450, title = "Variable Filters",
                   sliderInput("nrow","Count of Data", min = 100, max = 1000, value = 700),
                   selectizeInput("var1", "Variables for Plot 1", selected = "Cement", 
                                  choices = colnames(data %>% select(Cement:Strength))),
                   selectizeInput("var2", "Variable for Plot 2", selected = "Cement", 
                                  choices = colnames(data %>% select(Cement:Strength)))
               )),
        column(8,
          box(width = NULL, height = 450, title = "PLOT 2", plotOutput("plot_2"))
        )
      )
          
        ),
    tabItem(tabName = "model",
            tabsetPanel(
              tabPanel("Modeling Theory",
                       fluidRow(
                         column(12,
                                box(width=NULL,title="Linear Regression",
                                    status = "danger",
                                    h4("The linear regrerssion takes the form"),
                                    h4(""),
                                    withMathJax(),
                                    helpText('$$y = \\beta_0 + \\beta_1 \\cdot x_1 + 
                         \\beta_2 \\cdot x_2 + \\beta_3 \\cdot x_3 + ... + \\beta_n \\cdot x_n$$'),
                                    h4("The x’s are the independent variable called predictor and the y is dependent variable called as response. The key assumption of linear regression are:"),
                                    h4(""),
                                    h4("1. The variance of the error term (e) is constant and it’s expected value is 0."),
                                    h4(""),
                                    h4("2. The error term (e) is normally distributed."),
                                    h4(""),
                                    h4("3. The predictor variables are uncorrelated with each other."),
                                    h4("Linear regression is a parametric model. Thus, it has low flexibility. On other hand, it is simple to use and can be easily explained to people without statistics background. Thus, it has high interpretability."),
                                    h4("The non linearilty in the data can be captured by the linear regression using polynomial terms of x's")
  
                          )
                         )
                       ),
                       fluidRow(
                         column(12,
                                box(width=NULL,title="Regression Decision Tree",
                                    status="danger"
                                    
                                    
                                )
                         )
                       ),
                       fluidRow(
                         column(12,
                                box(width=NULL,title="Random Forest Model",
                                    status="danger"
                                    
                                )
                         )
                       )
              )
      
    )
      ),
    tabItem(tabName = "data",
      column(4, 
             box(width = 18, background = "red", title = "Select Variable", 
                 checkboxGroupInput("variable_for_data",
                                    "Variables For Data", c("Cement" = "Cement",
                                                           "Furnace"= "Blast.Furnace.Slag",
                                                           "Ash" = "Fly.Ash", "Water" = "Water",
                                                           "Superplasticizer" = "Superplasticizer",
                                                           "Coarse" = "Coarse.Aggregate",
                                                           "Fine" = "Fine.Aggregate", "Age"= "Age",
                                                           "Strength"="Strength"), 
                                    selected = c("Cement", "Blast.Furnace.Slag", "Fly.Ash", "Water", 
                                                 "Superplasticizer", "Strength", "Coarse.Aggregate",
                                                 "Fine.Aggregate", "Age"))),
             sliderInput("nrow_records","Fraction of Records", min = 0.02, max = 0.8, value = 0.1),
             downloadButton('downloadData', 'Download data')),
      column(8,
             box(width = 24, height = 650, title = "Modeling Data", 
                 dataTableOutput("variable_for_data")))
      
            )
      )
    ))
