# 4) Ranking hospital in all states

setwd("D:/Books and Mag/Coursera notes John Hopkins Data Science/R files/Module 2/Assignment 3 hospital data file")
outcomes <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
outcomes[ , 11] <- as.numeric(outcomes[ , 11])
outcomes[ , 17] <- as.numeric(outcomes[ , 17])
outcomes[ , 23] <- as.numeric(outcomes[ , 23])
outcomes <- outcomes[, c(2,11,17,23,7) ]

rankall <- function(outcome, num = "best"){
        
        disease <- if(outcome == "heart attack"){
                outcomes[ ,c(1,2,5)]
        }else if(outcome == "heart failure"){
                outcomes[ ,c(1,3,5)]
        }else if(outcome == "pneumonia"){
                outcomes[ ,c(1,4,5)]
        } 
        
        order <- disease[order(disease[ ,3], disease[ ,2], disease[ ,1]), ]
        which = is.na(order[ ,2])==F
        order <- order[which, ]
        order1 <- split(order, order[ ,3])
        
        
        if(num == "best"){
                order2<-sapply(order1, function(x){num = 1;x[num,1]})
        }
        else if(num == "worst") {
                order2<-sapply(order1, function(x){num <- nrow(x);x[num,1]})
        }
        else{
                order2<-sapply(order1, function(x){x[num,1]})
        }
        
        final <- as.matrix(order2)
        colnames(final) <- "Hospital Name"
        final
        
}

rankall("heart attack",20)
rankall("pneumonia","worst")
rankall("heart failure")




#===================================================
setwd("D:/Books and Mag/Coursera notes John Hopkins Data Science/R files/Module 2/Assignment 3 hospital data file")
outcomes <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
outcomes[ , 11] <- as.numeric(outcomes[ , 11])
outcomes[ , 17] <- as.numeric(outcomes[ , 17])
outcomes[ , 23] <- as.numeric(outcomes[ , 23])
outcomes <- outcomes[, c(2,11,17,23,7) ]
library(dplyr)

disease <- function(outcome){
        if(outcome == "heart attack"){
                outcomes[ ,c(1,2,5)]
        }else if(outcome == "heart failure"){
                outcomes[ ,c(1,3,5)]
        }else if(outcome == "pneumonia"){
                outcomes[ ,c(1,4,5)]
        }
}
disease <- disease("pneumonia")

rankall1 <- function(disease){
        library(dplyr)
        order <- arrange(disease, disease[ ,3], disease[ ,2], disease[ ,1])
        which = is.na(order[ ,2])==F
        order <- order[which, ]
        order1 <- split(order, order[ ,3])
        order1
}
order2 <- rankall1(disease)
y <- lapply(order2, function(x){ num <- nrow(x); x[num,1]})
y <- as.data.frame(y)
y <- t(y)