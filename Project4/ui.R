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
dashboardPage(skin = "blue",
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
            column(6,box(width=NULL,height=45,background="orange",
                         title="App Information",
                  h4("The app provides information regarding the source data. Based on the data, 
                  exploratory data analysis plots will be created as per the variables and plot 
                  type selected by the user. The app also has a modelling page which has 
                  information regarding how each models fits and train the data. Finally, the 
                  app will also display the predicted value of testing dataset"))
                   ),
            column(6,box(width=NULL,height=45,background="orange",
                         title="Discussion of data and its source",
                  h4("The dataset is obtained from kaggle. The url is https://www.kaggle.com/datasets/prathamtripathi/regression-with-neural-networking
The dataset provides details of the individual elements present in the mixture of cement. The goal
is to predict the strength of concrete produced. More the strength, better it is for the
construction company."))
            )
          )
        )
      )
    )
)
