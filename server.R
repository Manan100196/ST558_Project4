
library(shiny)
library(tidyverse)
library(ggcorrplot)
library(car)
library(caret)

#Uploading data and pre-processing it
data <- read.csv("concrete_data.csv")
process <- preProcess(as.data.frame(data), method=c("range"))
data <- predict(process, as.data.frame(data))
data$water_category <- ifelse(data$Water>0.5, 1, 0)
data$cement_category <- ifelse(data$Cement>0.5,1,0)
data$strength_category <- ifelse(data$Strength>0.5,1,0)

shinyServer(function(input, output) 
  {
  # Image for About page 
  output$image<-renderImage({
    list(src='Concrete.jpg')
  }, deleteFile = FALSE)
  
  # Data Exploration
  cont_func <- reactive({
    cont_val <- c(input$cont_var, input$plot1, input$plot2, input$var1, input$var2, input$nrow)
  })
  random_data <- reactive({
    filter_data <- data[sample(nrow(data), cont_func()[6]),]
  })
  # Contigency table
  output$table_contingency <- renderTable({
    filter_data <- random_data()
    if(cont_func()[1] == "water"){
      table(filter_data$water_category, filter_data$strength_category)
    }else{
      table(filter_data$cement_category,filter_data$strength_category)
    }
  })
  # Plot 1
  output$plot_1 <- renderPlot({
    filter_data <- random_data()
    if(cont_func()[2] == "Bar Graph"){
      ggplot(data=filter_data, aes(x=strength_category)) + geom_bar()
    }else{
      plot(seq(1:cont_func()[6]), filter_data[,cont_func()[4]], xlab = "Number of Records", ylab = cont_func()[4], 
           type = "l")
    }
  })
  # Plot 2
  output$plot_2 <- renderPlot({
    filter_data <- random_data()
    if(cont_func()[3] == "Scatter Plot"){
      plot(filter_data[,"Strength"], filter_data[,cont_func()[5]], xlab = "Strength", ylab = cont_func()[5])
    }else{
      filter_data_2 <- filter_data %>% select(Cement:Strength)
      ggcorrplot(round(cor(filter_data_2 ), 1))
    }
  })
  
  # Modeling
  split<-eventReactive(input$run_model,{
    input$split
  })
  var_lm<-eventReactive(input$run_model,{
    input$variable_for_lm
  })
  var_reg_tree<-eventReactive(input$run_model,{
    input$variable_for_regression
  })
  reg_tree_cp<-eventReactive(input$run_model,{
    input$regression_depth
  })
  var_rf<-eventReactive(input$run_model,{
    input$variable_for_random_forest
  })
  num_trees_rf <- eventReactive(input$run_model,{
    input$num_trees
  })
  
  # Linear Regression
  output$linear_reg <- renderText({
    train_size <- sample(nrow(data), nrow(data)*split())
    data_for_train <- data[train_size,]
    data_for_test <- data[-train_size,]
    train_data <- data_for_train %>% select(var_lm())
    test_data <- data_for_test %>% select(var_lm())
    
    lm_fit <- lm(Strength~., data = train_data, trControl=trainControl(method = "repeatedcv", number = 7, repeats = 3))
    lm_predict <- predict(lm_fit,test_data)
    lm_test_mse <- mean((test_data$Strength-lm_predict)^2)
    print(lm_test_mse)
  })
  
  # Regression Tree
  output$reg_tree <- renderText({
    train_size <- sample(nrow(data), nrow(data)*split())
    data_for_train <- data[train_size,]
    data_for_test <- data[-train_size,]
    train_data <- data_for_train %>% select(var_reg_tree())
    test_data <- data_for_test %>% select(var_reg_tree())
    
    reg_tree_fit <- train(Strength~., data = train_data, 
                          method = "rpart",
                          trControl=trainControl(method = "repeatedcv", number = 7),
                          tuneGrid = (expand.grid(cp = reg_tree_cp())))
    
    reg_tree_predict <- predict(reg_tree_fit,test_data)
    reg_tree_mse <- mean((test_data$Strength-reg_tree_predict)^2)
    print(reg_tree_mse)
  })
  
  # Random Forest
  output$random_forest <- renderText({
    train_size <- sample(nrow(data), nrow(data)*split())
    data_for_train <- data[train_size,]
    data_for_test <- data[-train_size,]
    train_data <- data_for_train %>% select(var_rf())
    test_data <- data_for_test %>% select(var_rf())
    
    rf_fit <- train(Strength~., data = train_data, 
                          method = "rf",
                          tuneGrid = expand.grid(mtry=ncol(train_data)/3),
                          ntree = num_trees_rf(),
                          trControl=trainControl(method = "repeatedcv", number = 7),
                          )
    
    rf_predict <- predict(rf_fit,test_data)
    rf_mse <- mean((test_data$Strength-rf_predict)^2)
    print(rf_mse)
  })
  
  # Data page
  filter_row_data <- reactive({
    row_data <- data %>% sample_frac(input$nrow_records, replace = FALSE)
  })
  # Data table
  output$variable_for_data <- renderDataTable({
    #var_filter_data <- data %>% sample_frac(input$nrow_records, replace = FALSE)
    var_filter_data <- filter_row_data() %>% select(input$variable_for_data)
  }, options = list(pageLength = 10, columnDefs = list(list(targets = 4))))
  # Download data
  output$downloadData <- downloadHandler(
    filename = function() { 
      paste("Concrete-Strength", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      data <- filter_row_data() %>% select(input$variable_for_data) 
      write.csv(data, file)
    })
})


