library(shiny)
library(shinydashboard)

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
                  h4("The app provides information regarding the concrete strength data. Based on the data, 
                  plots will be created as per the variables, number of samples and plot 
                  type selected by the user. The app also has a modelling page where different
                  machine leaning models are deployed. Based, on the selection of the model, respective
                  model results will be displayed. FInally, the user can download the data and visualize
                  the filter data as well."))
                   ),
            column(6,h1("Discussion of data"),
                   box(width=NULL,background="red",
                  h4("The dataset is obtained from kaggle. The url is https://www.kaggle.com/datasets/prathamtripathi/regression-with-neural-networking
The dataset provides details of the individual elements (cement, water, ash etc.) present in the mixture of concrete. The goal
is to predict the strength of concrete produced. More the strength, better it is for the
construction company."))
            )
          ),
        fluidRow(
          column(12, h1("Purpose of each page"),
                 box(width=NULL,height=250,background="red",
                h4("The first page is an about page which briefly summarize the purpose of the app and what features it has."),
                h4("The second page has numerical (contingency table) anmd graphical summaries (bar plot, scatter plot etc.). The plots and summary tables are customized as per user input and selection"),
                h4("The third page is a modeling page where based on the variables and model selected, the model is fitted and prediction on testing data is obtained."),
                h4("The last page is where user can see the raw data of concrete strength. User can download the data from this page as well.")
                
          )
        )
        ),
        fluidRow(
          column(12,h1("Image"),
                 
                     imageOutput("image")
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
                                box(width=NULL,title="Regression Tree",
                                    status="danger",
                                    h4("A regression tree is basically a decision tree that is used for the task of regression which can be used to predict continuous valued outputs.
                                       A regression tree is built through a process known as binary recursive partitioning, which is an iterative process that splits the data into partitions or branches, and then continues splitting each partition into smaller groups as the method moves up each branch."),
                                    h4("Pruning: Since the tree is grown from the Training Set, a fully developed tree typically suffers from over-fitting (i.e., it is explaining random elements of the Training Set that are not likely to be features of the larger population). This over-fitting results in poor performance on real life data.")
                                    
                                    
                                )
                         )
                       ),
                       fluidRow(
                         column(12,
                                box(width=NULL,title="Random Forest Model",
                                    status="danger",
                                    h4("In bagging, a number of trees are created from a boostraped sample of data. The average of these trees is then used as prediction.
                                       Random Forest uses similar concept of bagging. The fundamental change is that the model uses feature randomness which is a random subset of features. This phenomenon ensures that there is low correlation among the decision trees created."),
                                    h4("The drawback of this method is that it is a black box method since it involves more complexity.")
                                    
                                )
                         )
                       )
              ),
            tabPanel("Model Fitting",
                  fluidRow(
                    br()
                  ),
                  fluidRow(
                     column(4,
                          box(width = 12, height = 320, background = "red", title = "Proportion of Training Data",
                              sliderInput("split","Proportion of Training Data", min = 0.5, max = 0.8, value = 0.7),
                          )
                       ),
                     column(8,
                            box(width = 18, title = "Select Variable for linear regression", 
                                checkboxGroupInput("variable_for_lm",
                                                   "Variables For Linear regression", c("Cement" = "Cement",
                                                                           "Furnace"= "Blast.Furnace.Slag",
                                                                           "Ash" = "Fly.Ash", "Water" = "Water",
                                                                           "Superplasticizer" = "Superplasticizer",
                                                                           "Coarse" = "Coarse.Aggregate",
                                                                           "Fine" = "Fine.Aggregate", "Age"= "Age",
                                                                           "Strength"="Strength"), 
                                                   selected = c("Cement", "Fly.Ash", "Water", 
                                                                "Superplasticizer", "Strength")))
                     )
                     ),
                  fluidRow(
                    column(4
                           ),
                    column(5,
                           box(width = 18, title = "Select Variable for Regression Tree", 
                               checkboxGroupInput("variable_for_regression",
                                                  "Variables For Regression", c("Cement" = "Cement",
                                                                          "Furnace"= "Blast.Furnace.Slag",
                                                                          "Ash" = "Fly.Ash", "Water" = "Water",
                                                                          "Superplasticizer" = "Superplasticizer",
                                                                          "Coarse" = "Coarse.Aggregate",
                                                                          "Fine" = "Fine.Aggregate", "Age"= "Age",
                                                                          "Strength"="Strength"), 
                                                  selected = c("Cement", "Fly.Ash", "Water", 
                                                               "Superplasticizer", "Strength")))
                    ),
                    column(3,
                           box(width = 18, height = 320, title = "Depth for Regression Tree",
                               sliderInput("regression_depth","Value of Cp", min = 0.001, max = 0.9, value = 0.02))
                           )
                  ),
                  fluidRow(
                    column(4,
                           box(width = 12, background = "red", height = 100, actionButton("run_model","Run the Model"))),
                    column(5,
                           box(width = 18, title = "Select Variable for Random Forest", 
                               checkboxGroupInput("variable_for_random_forest",
                                                  "Variables For Random Forest", c("Cement" = "Cement",
                                                                                   "Furnace"= "Blast.Furnace.Slag",
                                                                                   "Ash" = "Fly.Ash", "Water" = "Water",
                                                                                   "Superplasticizer" = "Superplasticizer",
                                                                                   "Coarse" = "Coarse.Aggregate",
                                                                                   "Fine" = "Fine.Aggregate", "Age"= "Age",
                                                                                   "Strength"="Strength"), 
                                                  selected = c("Cement", "Fly.Ash", "Water", 
                                                               "Superplasticizer", "Strength")))
                    ),
                    column(3,
                           box(width = 12, height = 320, title = "Depth for Random Forest",
                               sliderInput("num_trees","Number of Trees", min = 3, max = 8, value = 4))
                    )
                    
                  ),
                  fluidRow(
                    column(4,
                           box(width = 12, background = "green", title = "Test MSE for Linear Regression", textOutput("linear_reg"))),
                    column(4,
                           box(width = 12, background = "green", title = "Test MSE for Regression Tree", textOutput("reg_tree"))),
                    column(4,
                           box(width = 12, background = "green", title = "Test MSE for Random Forest", textOutput("random_forest")))
                  )
                  
            ),
            tabPanel("Prediction",
              fluidRow(
                br(),
                     column(4,
                            box(width = 12,background = "red", height = 150, title = "Select the Modeling Method",
                                selectizeInput("mod_method", "Modeling Method", selected = "Linear Regression", 
                                               choices = levels(as.factor(c("Linear Regression", "Regression Trees", 
                                                                            "Random Forest")))))),
                     column(4,
                       box(width = 12,background = "red", height = 450, title = "Enter the variable values",
                           numericInput("cement","Cement",min=0.5,max=5,value=1.5,step=0.5,
                                        width=300),
                           numericInput("furnace","Furnace",min=0.5,max=5,value=1,step=0.5,
                                        width=300),
                           numericInput("ash","Ash",min=0.5,max=5,value=2,step=0.5,
                                        width=300),
                           numericInput("water","Water",min=0.5,max=5,value=0.5,step=0.5,
                                        width=300),
                           
                           )
                       ),
                    column(4,
                      box(width = 12,background = "red", height = 450, title = "Enter the variable values",
                          numericInput("superplaticizer","Superplaticizer",min=0.5,max=5,value=1,step=0.5,
                                       width=300),
                          numericInput("coarse","Coarse",min=0.5,max=5,value=2.5,step=0.5,
                                       width=300),
                          numericInput("fine","Fine",min=0.5,max=5,value=1,step=0.5,
                                       width=300),
                          numericInput("age","Age",min=0.5,max=5,value=3,step=0.5
                          ))
                      )
                          
              
            ),
            fluidRow(
              column(12, box(width = 15, background = "green", title = "Predicted Value"
              ))
            )
            ))),
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
