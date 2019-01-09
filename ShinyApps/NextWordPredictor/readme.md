
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

## Frequency of word frequency

The frequency of word frequency are presented below.
```
alltext <- tm_map(all0, PlainTextDocument)
dtm <- DocumentTermMatrix(alltext)
freq <- colSums(as.matrix(dtm))
ord <- order(freq)
freq[head(ord)]
freq[tail(ord)]
```
From the output, we can see that there are 5389 words that appeared once and 1424 words that appeared twice. This suggests that the data is quite sparse.

```
head(table(freq), 15)
```
**Num = Number of times the word appeared**  
**Freq = number of words with this frequency**  


|   |    |      |      |      |       |      |      |      |      |       |         |     |      |      |      |  
|:---|:--- |:----:|:----:|:----:| :----:|:--- |:----:|:----:|:----:| :----:|   :----:|:--- |:----:|:----:|:----:|   
| **Num** |  1  |  2   | 3    | 4    |5      |6      |7    | 8     |      9|   10 |   11 |   12|   13|   14|   15| 
|  **Freq** |  5389  |  1424   | 697    | 380    | 290      |227      |167    | 138     |      124|   92 |   79 |   65|   72|   51|   43|   


There is one word that appeared 317 times and one word that appeared 311 times. Most of the words that appeared more than 60 times are unique, for example only one word appeared 62 times and one word appeared 63 times. However, there are 4 words that appeared 56 times and 5 words that appeared 49 times.

```
tail(table(freq), 70)

```

**Num = Number of times the word appeared**  
**Freq = number of words with this frequency** 
 
 
| | |    |      |      |      |       |      |      |      |      |       |       |     |      |    |      |     |     |  
|:---|:---|:--- |:----:|:----:|:----:| :----:|:--- |:----:|:----:|:----:| :----:|:----:|:--- |:----:|:---|:----:| :---|:---:|   
|**Num**|  47|  48 | 49   |  51  | 52   |  53   |  54 |  55  |  56  |58    |  59   |  60  |62   | 63   | 64 |  65  |  66 |  67 |  
|**Freq**|   1|   3 |  5   | 4    |  2   |  2    |  2  | 5    |4     | 2    | 2     | 2    | 1   |1     |4   |5     |3    |1    |  
|**Num**|  68|  70 | 72   |73    |76    | 77    |78   |79    |80    |81    |82     |86    |87   | 88   |90  |91    |92   |94   |  
|**Freq**|   3|   1 |  1   |1     |1     |3      | 3   |1     | 1    |  3   |1      |  1   | 2   |3     | 2  | 2    | 1   |1    |  
|**Num**| 95 |  99 | 102| 103| 104| 105| 106| 107| 112| 114| 115| 118| 126| 129| 132| 133| 137| 139|  
|**Freq**|   1|   1 |  1|   1|   1|   1|   1|   1|   1|   1|   1|   3|   1|   1|   1|   2|   1|   1|  
|**Num**| 142| 148| 157| 164| 167| 182| 196| 202| 205| 215| 233| 241| 256| 296| 311| 317|     
| **Freq**|   2|   1|   1|   1|   1|   1|   1|   1|   1|   1|   1|   1|   1|   1|   1|   1|  
  
  
## Unigram Wordcloud

A wordcloud of frequent one-words is created to help visualize the date.  
```
library(ggplot2)
library(wordcloud)
set.seed(123)
tone <- brewer.pal(6, "Dark2")
wordcloud(names(freq), freq, max.words=100, rot.per=0.2, colors=tone)
```

![Image of wordcloud](https://github.com/qwyeow/JHU_DataScience/blob/master/ShinyApps/NextWordPredictor/wordcloud.png)


## Ngrams

Unigram, bigram and trigrams are created using the ngram package. A frequency table and a bar graph are created for each ngram.

```
library(readr)
all1 <- sapply(all0, function(x){all0$content})
writeCorpus(all1, filenames = "corpus1.txt")
all2 <- read_lines("corpus1.txt")

ng1 <- ngram(all2, n=1)
ng2 <- ngram(all2, n=2)
ng3 <- ngram(all2, n=3)

df1 <- get.phrasetable(ng1)
df2 <- get.phrasetable(ng2)
df3 <- get.phrasetable(ng3)

```

### Unigram

The two most frequently occurring unigrams are “said” and “will”, both of which appeared more than 300 times. The word “know”, at 20th position, occurred more than 100 times.

```
head(df1,20)
```
  
  
| ngrams | freq |   proportion |   
|:---:|:---:|:---:|  
| 1  | said |   317| 0.006546205|  
| 2  | will |  311 | 0.006422303|  
| 3  |  one |  296 | 0.006112545|  
| 4  |  like|  256 | 0.005286526|  
| 5  | just |  241 | 0.004976768|  
| 6  | time | 233  | 0.004811564|  
| 7  | year | 215  | 0.004439855|  
| 8  | get  | 205  | 0.004233351|  
| 9  | can  |  202 | 0.004171399|  
| 10 | make | 196  | 0.004047496|  
| 11 | day  |  182 | 0.003758389|  
| 12 | go   | 176  | 0.003634486|  
| 13 | work | 167  | 0.003448632|  
| 14 | new  | 164  | 0.003386680|  
| 15 | peopl| 157  | 0.003242127|  
| 16 | love | 148  | 0.003056273|  
| 17 |  us  | 147  | 0.003035622|  
| 18 | think| 142  | 0.002932370|
| 19 |  say | 142  |0.002932370 |  
| 20 | know |  139 | 0.002870418 |  
  
```
df1top <- head(df1,20)
library(ggplot2)
p <- ggplot(df1top, aes(x=reorder(ngrams, freq), y=freq))
p <- p + geom_bar(stat="identity")
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))+
        xlab("1-gram")+
        ylab("Frequency")
p

```  

