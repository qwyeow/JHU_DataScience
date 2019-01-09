
Type in at least 3 words and [this app](https://wyquek71.shinyapps.io/Capstone_word_pred/) will predict the next word for you, alongside the scores of each prediction, and the ngram from which the prediction came.

![image of ahinyapps](https://github.com/qwyeow/JHU_DataScience/blob/master/ShinyApps/NextWordPredictor/NextWordPredictor_screenshot.png)


## EDA

### Downloading source files

The data is downloaded from website https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip
The size and length of each of the three files are shown below. All of them are large files, making it necessary to sample only a small portion of them for data exploration.

```
setwd("D:/Coursera-SwiftKey/final/en_US")
tweet <- readLines("en_US.twitter.txt", encoding = "UTF-8", skipNul = TRUE)
news <- readLines("en_US.news.txt", encoding = "UTF-8", skipNul = TRUE)
blog <- readLines("en_US.blogs.txt", encoding = "UTF-8", skipNul = TRUE)
tweetsize <- file.size("en_US.twitter.txt")
tweetlength <- length(tweet)
newssize <- file.size("en_US.news.txt")
newslength <- length(news)
bloglength <-length(blog)
blogsize <- file.size("en_US.blogs.txt")
```

| File        | Tweeter           | News  | Blog  |
| :------------- |:-------------:|:-----:|:------|
|Size(MB) | 	1.671053410^{8}| 	2.058118910^{8}| 	2.101600110^{8}|
|Length(lines)| 	2360148 |	77259| 	899288
  
  
### Meta-structure of the source files

The meta-structure of the source files are examined using ngram:string.summary. The gargantuan amount of punctuation, white spaces, digits and non-English words/characters demands extensive cleanup of the data.  

```
library(ngram)
tweetc <- concatenate(tweet)
newsc <- concatenate(news)
blogc <- concatenate(blog)

tweetsumary <- string.summary(tweetc)
newssummary <- string.summary(newsc)
blogsummary <- string.summary(blogc)

tweetsumary 
newssummary
blogsummary

```

|File |Tweeter |News |Blog
| :------------- |:-------------:|:-----:|:------|
|Characters |	164745182 | 	15761023 |	209260725|
|Letters |	125178704 | 	12377097 | 	163693133 |
|Whitespace | 	30374146 | 	2643985 |	37334649 |
|Punctuation | 	8018584 | 	529971 |	5976790 |
|Digits | 	1015471 | 	177753 |	985537 |
|Sentences | 	4346310 | 174879 | 2530958 |
