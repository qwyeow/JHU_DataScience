## Best State Hospital for 30 day Mortality

outcomes <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
head(str(outcomes))
outcomes[ , 11] <- as.numeric(outcomes[ , 11])
outcomes[ , 17] <- as.numeric(outcomes[ , 17])
outcomes[ , 23] <- as.numeric(outcomes[ , 23])


best <- function(state, outcome) {
        
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
        best <- which$ix          #[1:3]
        candidate <- yy[best, ]    #y$Hospital.Name[best]
        
        minimum <- min(candidate[ ,2],na.rm = T)        
        minimum1 <- candidate[ ,2]== minimum
        candidate <- candidate[minimum1,1]
        if(length(candidate)>1){
                candidate <- sort(candidate)
                candidate[1]        
        }
        
        final <- candidate #sort(candidate)
        print(paste("The best hospital in", state, "for", outcome, "is", final[1]))
}

best("AZ", "pneumonia")
best("TX", "heart attack")
#[1] "CYPRESS FAIRBANKS MEDICAL CENTER"
best("TX", "heart failure")
#[1] "FORT DUNCAN MEDICAL CENTER"
best("MD", "heart attack")
#[1] "JOHNS HOPKINS HOSPITAL, THE"
best("MD", "pneumonia")
#[1] "GREATER BALTIMORE MEDICAL CENTER"
best("BB", "heart attack")
#Error in best("BB", "heart attack") : invalid state
best("NY", "hert attack")
#Error


colnames(outcomes)

best("TX", "heart attack")
best("TX", "heart failure")
best("MD", "heart attack")
best("MD", "pneumonia")
best("BB", "heart attack")
best("NY", "hert attack")






outcome <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
outcome[ , 11] <- as.numeric(outcome[ , 11])
outcome[ , 17] <- as.numeric(outcome[ , 17])
outcome[ , 23] <- as.numeric(outcome[ , 23])

best <- function(state_chose) {
        state_chose <- outcome$State == state_chose
        y <- outcome[state_chose, c(2,11,17,23,7) ]
        y
}  

y <- best("TX")


disease <- function(disease){
        if(disease == "heart attack"){
                y[ ,c(1,2)]
        }else if(disease == "heart failure"){
                y[ ,c(1,3)]
        }else if(disease == "pneumonia"){
                y[ ,c(1,4)]
        }
}

yy <- disease("heart failure")


sort1 <- function(x){
        which <- sort(yy[ ,2], decreasing = F, index.return = T,na.last=TRUE)        
        best <- which$ix
        yy[best, ]
}
aaa <- sort1(yy)

tiebreak <- function(x){
        minimum <- min(x[ ,2],na.rm = T)        
        minimum1 <- x[ ,2]== minimum
        candidate <- x[minimum1,1]
        if(length(candidate)>1){
                candidate <- sort(candidate)
                candidate[1]        
        }
        
}


