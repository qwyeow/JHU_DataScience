library(shiny)
library(ElemStatLearn)
data(SAheart)

shinyServer(function(input, output) {
       model1 <- glm(chd ~ age + alcohol + obesity + tobacco + typea, family = "binomial", data = SAheart)
       
     
       model1pred <- reactive({
               ageInput <- input$slider1
               alcoholInput <- input$slider2
               obesityInput <- input$slider3 
               tobaccoInput <- input$slider4
               typeaInput <- input$slider5
               
               
               predict(model1, 
                       newdata = data.frame(age = ageInput, alcohol = alcoholInput, obesity = obesityInput,
                                            tobacco= tobaccoInput, typea= typeaInput ))
       })
        
      
       output$pred1 <- renderText({
               exp(model1pred())/(1+exp(model1pred()))*100
       
       })
    

       })
        
        
        

