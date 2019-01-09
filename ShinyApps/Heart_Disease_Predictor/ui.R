library(shiny)
library(plotly)


shinyUI(fluidPage(
        titlePanel("Coronary Heart Disease Predictor"),
        sidebarLayout(
                sidebarPanel(
                        sliderInput("slider1", "Age", 15, 65, 42.82),
                        sliderInput("slider2", "Alcohol consumption", 0, 150, 17.04),
                        sliderInput("slider3", "Obesity (based on BMI)", 14, 47, 26.04),
                        sliderInput("slider4", "Cumulative tobacco level", 0, 32, 3.6356),
                        sliderInput("slider5", "Bortner Short Rating Scale (Type A Behavior)", 13, 78, 53.1)
                       
                ),
                mainPanel(
                        tabsetPanel(type = "tabs", 
                                    tabPanel("Instruction", 
                                             p(" "),
                                             p("This simple web application calculates the probability of having Coronary Heart Disease based on five variables."),
                                             p("Just change the five slider values and see the probability value changes correspondingly.")),
                                             
                                             tabPanel("Probability of having Coronary Heart Disease (%) ", h1(textOutput("pred1"))) 
                                             
                                             
                                    ) 
                        
                       
                        
                )
        )
        )
)

                        
 