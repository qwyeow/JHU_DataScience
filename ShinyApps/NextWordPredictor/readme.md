
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


### Cleaning up the data

1000 lines are selected randomly from each of the three files, totaling 3000 lines. These randomly selected lines are combined into one single file. A profanity list from the internet is used to censure vulgarities from the date. The data is converted to a corpus before removing certain characteristics that are not helpful in language modeling, such as

1.    All casing are changed to lower casing.
2.    Stopwords (e.g.“I”, “you”, “and”) are removed.
3.    Numbers are removed.
4.    Punctuation are removed.
5.    White space are removed.

The data is then “stem” so that root words (e.g. “arrive”, “arrived”, “arrival” are converted to “arriv”) are kept.

```
library(tm)
library(ngram)
set.seed(123)
tweet_s <- sample(tweet, 1000, replace = FALSE, prob = NULL)
news_s <- sample(news, 1000, replace = FALSE, prob = NULL)
blog_s <- sample(blog, 1000, replace = FALSE, prob = NULL)

all0 <- concatenate(tweet_s ,news_s , blog_s)
all0 <- iconv(all0,   "UTF-8", "ASCII", "byte")
all0 <- Corpus(VectorSource(all0))

remove(tweet, news, blog, tweet_s, news_s, blog_s, tweetc, newsc, blogc)

all0 <- tm_map(all0, content_transformer(tolower))
profanity<-read.csv2("profanity_list.txt", sep = "\n")
profanity <- readLines("profanity_list.txt")
all0 <- tm_map(all0, removeWords, profanity)
all0 <- tm_map(all0, removeWords, stopwords("english"))
all0 <- tm_map(all0, removeNumbers)
all0 <- tm_map(all0, removePunctuation)
all0 <- tm_map(all0, stripWhitespace)
all0 <- tm_map(all0, stemDocument)
```
