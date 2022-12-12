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

shinyServer(function(input, output) {
  cont_func <- reactive({
    cont_val <- c(input$cont_var, input$plot1, input$plot2, input$var1, input$var2, input$nrow)
  })
  random_data <- reactive({
    filter_data <- data[sample(nrow(data), cont_func()[6]),]
  })
  output$table_contingency <- renderTable({
    filter_data <- random_data()
    if(cont_func()[1] == "water"){
      table(filter_data$water_category, filter_data$strength_category)
    }else{
      table(filter_data$cement_category,filter_data$strength_category)
    }
  })
  output$plot_1 <- renderPlot({
    filter_data <- random_data()
    if(cont_func()[2] == "Bar Graph"){
      ggplot(data=filter_data, aes(x=strength_category)) + geom_bar()
    }else{
      plot(seq(1:cont_func()[6]), filter_data[,cont_func()[4]], xlab = "Strength", ylab = cont_func()[4], 
           type = "l")
    }
  })
  output$plot_2 <- renderPlot({
    filter_data <- random_data()
    if(cont_func()[3] == "Scatter Plot"){
      plot(filter_data[,"Strength"], filter_data[,cont_func()[5]], xlab = "Strength", ylab = cont_func()[5])
    }else{
      filter_data_2 <- filter_data %>% select(Cement:Strength)
      ggcorrplot(round(cor(filter_data_2 ), 1))
    }
  })
  variable_data <- reactive({
    var_data <- c(input$variable_for_data, input$nrow_records)
  })
  output$variable_for_data <- renderDataTable({
    var_filter_data <- data %>% sample_frac(0.02, replace = FALSE)
    var_filter_data <- var_filter_data %>% select(variable_data()[1])
  })
  output$downloadData <- downloadHandler(
    filename = function() { 
      paste("Concrete-Strength", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      data <- data %>% select(Cement:Strength)
      write.csv(data, file)
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


