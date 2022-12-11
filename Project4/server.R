#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#install.packages("car")
library(shiny)
library(tidyverse)
library(ggcorrplot)
library(car)


data <- read.csv("/Users/mjiwtan/Downloads/concrete_data.csv")
# summary(data$Cement) # 275
# summary(data$Strength) # 50
# summary(data$Water) # 150
process <- preProcess(as.data.frame(data), method=c("range"))
data <- predict(process, as.data.frame(data))
data$water_category <- ifelse(data$Water>0.5, 1, 0)
data$cement_category <- ifelse(data$Cement>0.5,1,0)
data$strength_category <- ifelse(data$Strength>0.5,1,0)
#data <- as.data.frame(scale(data))




# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  cont_func <- reactive({
    cont_val <- c(input$cont_var, input$plot1, input$plot2, input$var1, input$var2, input$nrow)
  })
  random_data <- reactive({
    data <- data[sample(nrow(data), cont_func()[6]),]
  })
  output$table_contingency <- renderTable({
    data <- random_data()
    if(cont_func()[1] == "water"){
      table(data$water_category, data$strength_category)
    }else{
      table(data$cement_category,data$strength_category)
    }
  })
  output$plot_1 <- renderPlot({
    data <- random_data()
    if(cont_func()[2] == "Bar Graph"){
      ggplot(data=data, aes(x=strength_category)) + geom_bar()
    }else{
      plot(seq(1:cont_func()[6]), data[,cont_func()[4]], xlab = "Strength", ylab = cont_func()[4], 
           type = "l")
    }
  })
  output$plot_2 <- renderPlot({
    data <- random_data()
    if(cont_func()[3] == "Scatter Plot"){
      plot(data[,"Strength"], data[,cont_func()[5]], xlab = "Strength", ylab = cont_func()[5])
    }else{
      data <- data %>% select(Cement:Strength)
      ggcorrplot(round(cor(data), 1))
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


