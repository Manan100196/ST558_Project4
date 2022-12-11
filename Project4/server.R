#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(tidyverse)

data <- read.csv("/Users/mjiwtan/Downloads/concrete_data.csv")
# summary(data$Cement) # 275
# summary(data$Strength) # 50
# summary(data$Water) # 150
data$water_category <- ifelse(data$Water>150, 1, 0)
data$cement_category <- ifelse(data$Cement>275,1,0)
data$strength_category <- ifelse(data$Strength>50,1,0)





# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  cont_func <- reactive({
    cont_val <- c(input$cont_var, input$plot1, input$plot2, input$var1, input$var2)
  })
  output$table_contingency <- renderTable({
    if(cont_func()[1] == "water"){
      table(data$water_category, data$strength_category)
    }else{
      table(data$cement_category,data$strength_category)
    }
  })
  output$plot_1 <- renderPlot({
    if(cont_func()[2] == "Bar Graph"){
      ggplot(data=data, aes(x=strength_category)) + geom_bar()
    }else{
      ggplot(data = data, aes(x = strength_category, y = data$strength)) + geom_line()
    }
  })
    # output$distPlot <- renderPlot({
    # 
    #     # generate bins based on input$bins from ui.R
    #     x    <- faithful[, 2]
    #     bins <- seq(min(x), max(x), length.out = input$bins + 1)
    # 
    #     # draw the histogram with the specified number of bins
    #     hist(x, breaks = bins, col = 'darkgray', border = 'white',
    #          xlab = 'Waiting time to next eruption (in mins)',
    #          main = 'Histogram of waiting times')
    # 
    # })

})


