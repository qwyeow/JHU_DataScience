library(shiny)
library(tm)
library(readr)
library(tokenizers)
library(ngram)

file1 <- readLines("random_girl1_forum.txt", encoding = "ASCII", skipNul = TRUE)
file2 <- readLines("random_girl2_reddit.txt", encoding = "ASCII", skipNul = TRUE)
file3 <- readLines("random_girl3_blogcomments.txt", encoding = "ASCII", skipNul = TRUE)
file4 <- readLines("random_girl4_website.txt", encoding = "ASCII", skipNul = TRUE)

#concatenate all files into one
allfiles <- c(file1,file2,file3,file4)  
allfiles <- iconv(allfiles,   "UTF-8", "ASCII", sub = "")




#preprocessing
for (i in 1:length(allfiles)){
        allfiles[i] <- preprocess(allfiles[i], 
                                  case = "lower", remove.punct = FALSE,
                                  remove.numbers = TRUE, fix.spacing = TRUE)
}




#combine all files into one single string for building ngrams
allfiles <- concatenate(lapply(allfiles,"[", 1))




##create ngrams 
ng1<- list();ng2<- list();ng3<- list();ng4<- list();ng5<- list()
ngrams <- list(ng1,ng2,ng3,ng4,ng5)
for (j in 1:length(ngrams))  {for (i in 1:length(allfiles)){
        ngrams[[j]] <- ngram(allfiles[i], n=j)}}




# Define server logic required to draw a histogram
shinyServer(function(input, output){
        
        observeEvent(input$button, {
                
        })
        
        predict<- eventReactive(input$tweets, {
                i <- sample(2:5,1,prob = c(20,40,6,3))  
                babbling <- babble(ngrams[[i]] , 50)
                subbabbling <- unlist(strsplit(babbling, '[.]'))                
                subbabbling[[1]]
        })
        
        output$sentence <- renderText({predict()})
        
})

