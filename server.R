#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
    diamondsSubset = diamonds[sample(nrow(diamonds),5000),]
    
    
    model1 <- lm(price ~ carat, data = diamondsSubset)
    model2 <- lm(price ~ carat + depth, data = diamondsSubset)
    model3 <- lm(price ~ carat + depth + color, data = diamondsSubset)
    
    model1Pred <- reactive({
        caratInput <- input$sliderCarat
        print(caratInput)
        predict(model1, newdata = data.frame(carat = caratInput))
    } )
    
    model2Pred <- reactive({
        caratInput <- input$sliderCarat
        depthInput <- input$sliderDepth
        predict(model2, newdata = data.frame(carat = caratInput, depth = depthInput))
    } )
    
    model3Pred <- reactive({
      caratInput <- input$sliderCarat
      depthInput <- input$sliderDepth
      colorInput <- input$color
      predict(model3, newdata = data.frame(carat = caratInput, color = as.factor(colorInput)
                                           ,depth = depthInput))
    } )
    
    plot1 <- plot_ly(diamondsSubset,x=diamondsSubset$price, y=diamondsSubset$carat)
    
    
    output$plot1 <- renderPlotly({

      fig <- plot1
      if (input$values == "carat"){
        pricePredict = model1Pred()
        fig <- fig %>% add_annotations(x = pricePredict,y=input$sliderCarat, name = 'Predicted value'
                                     , text = 'Predicted value')
      }
      fig
      })

      
  output$plot2 <- renderPlotly({

      fig <- plot_ly(diamondsSubset,x=diamondsSubset$price, y=diamondsSubset$carat, z=diamondsSubset$depth,
                     type = 'scatter3d', mode='markers')
      if (input$values == "depth"){
        pricePredict = model2Pred()
      fig <- fig %>% add_trace(x = pricePredict, y = input$sliderCarat, z = input$sliderDepth,
                                     name = 'Predicted value',mode='text', type = 'scatter3d'
                                     , text = 'Predicted value', color='red'
                               ,hoverinfo='skip',opacity=1, marker = list(color = "red"))
      }
      fig
    })
    
    output$plot3 <- renderPlotly({
      fig <-plot_ly(diamondsSubset,x=diamondsSubset$price, y=diamondsSubset$carat, z=diamondsSubset$depth,
                    color= as.numeric(diamondsSubset$color), type = 'scatter3d',mode='markers')
      
      if (input$values == "color"){
        pricePredict = model3Pred()
        fig <- fig %>% add_trace(x = pricePredict, y = input$sliderCarat, z = input$sliderDepth,
                                 name = 'Predicted value',mode='text', type = 'scatter3d'
                                 , text = 'Predicted value', color='red'
                                 ,hoverinfo='skip',opacity=1, marker = list(color = "red"))
      }
      
      fig
      
    })
    
    
    
    output$pred1<- renderText({
      if (input$values == "carat"){
        model1Pred()
      }else{ 
        ""
      }
    } )
    
    output$pred2<- renderText({
      if (input$values == "depth"){
        model2Pred()
      }else{
        ""
      }
    } )
    
    output$pred3<- renderText({
      if (input$values == "color"){
        model3Pred()
      }else
        ""
    } )
    
    
})