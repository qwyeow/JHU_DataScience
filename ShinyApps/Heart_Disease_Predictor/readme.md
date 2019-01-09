
This [simple web application](https://wyquek71.shinyapps.io/shinyappassignment/) calculates the probability of having Coronary Heart Disease based on five variables.
Just change the five slider values and see the probability value changes correspondingly.

![image of Webapp](https://github.com/qwyeow/JHU_DataScience/blob/master/ShinyApps/Heart_Disease_Predictor/Mockup.png)
### Documentation

This Shiny Apps calculates the risk of having coronary heart disease, expressed in probabilily.

The predictive model is trained using logistic regression by running the Generlized Linear Model under the binomial distribution family. 

The dataset used to train the predictive model comes from "SAheart dataset: from library(ElemStatLearn). Although there are nine variables and one response (chd) in this dataset, only five of the variables are chosen heuristically, namely, Age (age), Alcohol consumption (alcohol), Obseity (obesity), Cumulative tobacco level (tobacco) and Bortner Short Rating Scale for type A behaviour (typea). Except for the variable Age, these variables are selected for the sole reason that any behaviorial action in the person can lead to a change in the variable value. As examples, the person might decide to smoke or drink less, exercise more or adopt a more relaxing life atitude i.e. adopt type B behaviour.

The default value of each slider is set at the mean of the particular variable. For example, the mean of Obesity in SAheart dataset is 26, and as such the default value of the Obesity slider is set at 26. 


The minimum and maximum value of the slider are correspondinly the lowest and highest value foung in that paricular vairable. For example, Type A Behaiour is set at minimally 13 and maximallu 78 as these are the minimum and highest values found in the variable typea.

As one adjust the values of these five sliders, the probabilty of having coronary heart disease will change instansteanously based on each new combination of these five variables.

The probabiltity of having coronary heart disease is calcualted based on logistic regression using chd as the response and five predictors.  The expit function is used to convert the log odds output into probabilities which lies between the value 0 and 1.

END
 
