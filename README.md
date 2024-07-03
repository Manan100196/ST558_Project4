# ST558_Project4

Here, an app is developed to predict the concrete strength. The quality of concrete is important for the construction company and it is determined based on the composition of various element such as ash, water, cement etc. The app is developed to determine what will be the concrete strength based on proportion of the elements used. The assumption is same type or grade of individual elements are used in the mixture. To predict the strength, three machine learning models which are linear regression, random forest and regression tree are used. The user has the flexibility to decide the train test sp and variables to be used in the model. The app also has displays various plots of variables as per the input provided by the user. 

The code to install the packaged are:
```install.packages(c("caret", "tidyverse","shiny","shinydashboard", "ggcorrplot","car"))```

The above packages after installation needs to be selected. The code for package selection is:
```
library(shiny)
library(shinydashboard)
library(caret)
library(tidyverse)
library(ggcorrplot)
library(car)
```
