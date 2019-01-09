        library(shiny)
        library(stringr)
        library(tm)
        #library(dplyr)
        
        
        
        #load data files
        df4 <- readRDS("df42.rds")
        df3 <- readRDS("df32.rds")
        df2 <- readRDS("df22.rds")
        df1 <- readRDS("df12.rds")
        
        #ngram spliter
        ngram_pred <- function(text){
        splitword <- strsplit(text, " ")
        tail3 <- tail(splitword[[1]], n=3)
        
        last3 <- paste("^", tail3[[1]], " ",tail3[[2]]," ", tail3[[3]]," ", sep = "", collapse = NULL)
        match1st3 <- grepl(last3, df4$ngrams)
        match3 <- df4[match1st3, ]
        splitmatch3 <- strsplit(match3$ngrams, " ")
        lastword_3gram <- lapply(splitmatch3, function(splitmatch3) tail(splitmatch3, n=1)) 
        lastword_3gram <- head(lastword_3gram, 5) 
        
        last2 <- paste("^", tail3[[2]], " ",tail3[[3]]," ", sep = "", collapse = NULL)
        match1st2 <- grepl(last2, df3$ngrams)
        match2 <- df3[match1st2, ]
        splitmatch2 <- strsplit(match2$ngrams, " ")
        lastword_2gram <- lapply(splitmatch2, function(splitmatch2) tail(splitmatch2, n=1)) 
        lastword_2gram <- head(lastword_2gram, 5)
        
        last1 <- paste("^", tail3[[3]], " ", sep = "", collapse = NULL)
        match1st1 <- grepl(last1, df2$ngrams)
        match1 <- df2[match1st1, ]
        splitmatch1 <- strsplit(match1$ngrams, " ")
        lastword_1gram <- lapply(splitmatch1, function(splitmatch1) tail(splitmatch1, n=1)) #good lappy        
        lastword_1gram <- head(lastword_1gram, 5)
        
        
        
        #print(c(lastword_3gram, lastword_2gram, lastword_1gram) ) 
        
        fourgramcount <- match3$freq
        threegramtotal <- sum(match3$freq)
        Score_fourgram <- fourgramcount/threegramtotal*100
        Word_Score <-Score_fourgram
        Word_Predicted <-lastword_3gram
        Ngram_source <- "Quadgram"
        if(length(lastword_3gram) != 0){
        fourgram_and_score <- cbind(Word_Predicted, Word_Score, Ngram_source)
        }else{
        fourgram_and_score <- NULL    
        }
       
        
        threegramcount <- match2$freq
        twogramtotal <- sum(match2$freq)
        Score_threegram <- 0.4*threegramcount/twogramtotal*100
        Ngram_source3 <- "Trigram"
        if(length(lastword_2gram) != 0){
        threegram_and_score <- cbind(lastword_2gram, Score_threegram, Ngram_source3)
        }else{
        threegram_and_score <- NULL       
        }
        
        twogramcount <- match1$freq
        onegramtotal <- sum(match1$freq)
        Score_twogram <- 0.4*0.4*twogramcount/onegramtotal*100
        Ngram_source2 <- "Bigram"
        twogram_and_score <- cbind(lastword_1gram, Score_twogram,Ngram_source2)
        if(length(lastword_1gram) != 0){
        twogram_and_score <- cbind(lastword_1gram, Score_twogram, Ngram_source2)
        }else{
        twogram_and_score <- NULL
        }
        
        WordPredicted <- df1$ngrams
        unigramcount <- df1$freq
        unigramtotal <- sum(df1$freq)
        WordScore <- signif(100*0.4*0.4*0.4*unigramcount/unigramtotal, 2)
        NgramSource <- "Unigram"
        unigram_and_score <- cbind(WordPredicted, WordScore, NgramSource)

        allscores <- rbind(fourgram_and_score, threegram_and_score, twogram_and_score)
        #print(head(allscores,10))
        #dup <- duplicated(allscores[ ,1])
        #nodup <- allscores[!dup]
        #return(head(nodup,10))
        top20 <-head(allscores,20)
        dup <- duplicated(top20[ ,1])
        nodup <- top20[!dup, ]
        if(length(nodup)== 0){
        print(head(unigram_and_score, 10))
        }else{
        print(head(nodup,10))
        }
        }
        
        
        #clean input text
        cleantext <- function(text){
                text <- tolower(text)
                text <- removeNumbers(text)
                text <- removePunctuation(text)
                #profanity <- readline(profanity_list)
               
        }

        #stupid backoff
                stupid_backoff <- function(match3,match2,match1,lastword_3gram,lastword_2gram,lastword_1gram){
                
                fourgramcount <- match3$freq
                threegramtotal <- sum(match3$freq)
                Score_fourgram <- fourgramcount/threegramtotal
                fourgram_and_score <- cbind(lastword_3gram, Score_fourgram)
                
                threegramcount <- match2$freq
                twogramtotal <- sum(match2$freq)
                Score_threegram <- 0.4*threegramcount/twogramtotal
                threegram_and_score <- cbind(lastword_2gram, Score_threegram)
                
                twogramcount <- match1$freq
                onegramtotal <- sum(match1$freq)
                Score_twogram <- 0.4*0.4*twogramcount/onegramtotal
                twogram_and_score <- cbind(lastword_1gram, Score_twogram)
                
                allscores <- rbind(fourgram_and_score, threegram_and_score, twogram_and_score)
                #allscores <-data.frame(allscores)
                #select(allscores, petal_length = Petal.Length)
                #head(allscores,10)
                dup <- duplicated(allscores[ ,1])
                nodup <- allscores[!dup]
                head(nodup,10)
        }
        
        
        
        
        #shiny server

shinyServer(function(input, output){
        
        predict <- reactive({
        text <- input$text1  
        text <- cleantext(text)
        ngram_pred(text)
        #stupid_backoff()
        })
        
        #output$output1 <- renderText(prediction())
        output$output1 <- renderTable(predict()
        
        )
        
        
        
        

})


