# 3) Ranking hospitals by outcome in a state 

outcomes <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
head(str(outcomes))
outcomes[ , 11] <- as.numeric(outcomes[ , 11])
outcomes[ , 17] <- as.numeric(outcomes[ , 17])
outcomes[ , 23] <- as.numeric(outcomes[ , 23])

rankhospital <- function(state, outcome, num = "best"){
        
        z <- outcomes$State
        zz <- intersect(state,z)
        if (length(zz) == 0){
                stop("invalid state")
        }
        
        b <- c("heart attack", "heart failure","pneumonia")
        cc <- intersect(outcome,b)
        if (length(cc) == 0){
                stop("invalid outcome")
        }
        
        
        state_chose <- outcomes$State == state
        y <- outcomes[state_chose, c(2,11,17,23) ]
        
        yy <- if(outcome == "heart attack"){
                y[ ,c(1,2)]
        }else if(outcome == "heart failure"){
                y[ ,c(1,3)]
        }else if(outcome == "pneumonia"){
                y[ ,c(1,4)]
        }
        
        which <- sort(yy[ ,2], decreasing = F, index.return = T, na.last=TRUE)        
        best <- which$ix          
        candidate <- yy[best, ]   
        candidate
        
        
        sortby30 <- tapply(candidate[ ,1],candidate[ ,2], sort)
        final_ranking <- unlist(sortby30)
        
        if(num == "best"){
                num <- 1
        }else if(num == "worst"){
                num = length(final_ranking)
        }
        
        final_ranking[num]
        
}        

rankhospital("TX", "heart failure", 4)
rankhospital("MD", "heart attack", "worst")
rankhospital("MN", "heart attack", 5000)

