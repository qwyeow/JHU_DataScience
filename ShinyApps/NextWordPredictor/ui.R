library(shiny)


shinyUI(fluidPage(
        titlePanel("Capstone Project - Next Word Predictor"),
        sidebarLayout(
        sidebarPanel(
           textInput("text1", label = h4("Please type in at least three words here:"),
                     value = "Type in your sentence here and see what" )
           
       ),
        mainPanel(
        h3("The Most Probable Word and Its Corresponding Score:"),      
        tableOutput("output1"),
        h4("1st column: the predicted word"),
        h6("The most likely word, followed by the next most likely, followed by the next next..."),
        h4("2nd column: the stupid back-off score."),
        h6("The higher the score, the more probable the word."),
        h4("3rd column: the ngram used in predicting the word"),
        h6("Provides the ngram from which the prediction came. The highest-count unigrams are generated if the apps is unable to generate a prediction. ")

       )
    )
))



