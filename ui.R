#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)


# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Predict diamond price"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            
            radioButtons("values", "which values do you have?",
                         c("Carat (Model 1)" = "carat",
                           "Carat and detph (Model 2)" = "depth",
                           "Carat, depth and color (Model 3)" = "color")),
            sliderInput("sliderCarat",
                        "What is the weigth of the diamond?",
                        min = min(diamonds$carat),
                        max = max(diamonds$carat),
                        value = 2),
            sliderInput("sliderDepth",
                        "What is the depth of the diamond?",
                        min = min(diamonds$depth),
                        max = max(diamonds$depth),
                        value = 70),
            radioButtons("color", "color:",
                         levels(diamonds$color)),
            
            
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotlyOutput("plot1"),
            h3("Predicted price model 1:"),
            textOutput("pred1"),
            plotlyOutput("plot2"),
            h3("Predicted price model 2:"),
            textOutput("pred2"),
            plotlyOutput("plot3"),
            h3("Predicted price model 3:"),
            textOutput("pred3"),
        )
    )
))