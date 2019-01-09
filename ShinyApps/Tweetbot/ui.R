library(shiny)
shinyUI(fluidPage(
        
        titlePanel("Ahput 2.0"),
        
        sidebarLayout(
                sidebarPanel(
                        h5("Press button to get Ahputbot to tweet a sentence"),
                        actionButton("tweets", label = "Tweet")),
                
                
                mainPanel(
                        h2(textOutput("sentence"))
                        
                        
                )
        )
))