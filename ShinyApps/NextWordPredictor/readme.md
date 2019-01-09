
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

![image of unigram](https://github.com/qwyeow/JHU_DataScience/blob/master/ShinyApps/NextWordPredictor/unigram.png)  

### Bigram

The top twenty 2-grams appeared to be clustered between appearing 10 and 28 times.  

```
head(df2,20)

```

|ngrams|freq|proportion|  
|:---:|:---:|:---:|  
| 1   | new york | 23 0.0004749711|  
| 2   | high school | 23 0.0004749711|  
| 3   |  last year | 23 0.0004749711|  
| 4   | beep beep | 21 0.0004336693|  
| 5   | feel like | 18 0.0003717165|  
| 6   | year ago | 16 0.0003304147 |  
| 7   | new jersey | 15 0.0003097638|  
| 8   | right now | 15 0.0003097638 |  
| 9   | last week | 14 0.0002891128 |  
| 10  | one day | 14 0.0002891128 |  
| 11  | look like | 12 0.0002478110|  
| 12  | first time | 12 0.0002478110|  
| 13  | look forward | 11 0.0002271601|  
| 14  | will make | 11 0.0002271601|  
| 15  | two year  |11 0.0002271601 |  
| 16  | everi day | 11 0.0002271601|  
| 17  |  st loui  | 10 0.0002065092 |  
| 18  | unit state| 10 0.0002065092 |  
| 19  |  next year| 10 0.0002065092 |  
| 20  |  can get  |   9 0.0001858583|  
  
  
```
df2top <- head(df2,20)
p <- ggplot(df2top, aes(x=reorder(ngrams, freq), y=freq))
p <- p + geom_bar(stat="identity")
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))+
        xlab("2-gram")+
        ylab("Frequency")
p
```

![image of unigram](https://github.com/qwyeow/JHU_DataScience/blob/master/ShinyApps/NextWordPredictor/bigram.png)  

## Trigram

There are very few 3-grams with high counts. The highest is “beep beep beep” at 20 counts, which most likely is an anomaly. The second highest count is “presid barrack obama”, which is not surprising. Given the low word counts of 3-gram, relying too much on them to predict the next word may be counterproductive due to over-fitting.

```
head(df3,20)
```

| ngrams | freq | proportion |  
|:---:|:---:|:---:|  
| 1   |   beep beep beep |  20 4.130269e-04|  
| 2   |   nation intern news|     3 6.195403e-05|  
| 3  |   high school graduat|     3 6.195403e-05|  
| 4  |     movi like matilda|     3 6.195403e-05|  
| 5  |           let us know |    3 6.195403e-05|  
| 6  |   presid barack obama |    3 6.195403e-05|  
| 7  |  school school school |   2 4.130269e-05|  
| 8  |          se lake road |  2 4.130269e-05|  
| 9  |        word art sheet | 2 4.130269e-05|  
| 10 | counti sheriff depart |    2 4.130269e-05|  
|11 |     peopl realli need |    2 4.130269e-05|  
| 12 |    stoller dayton son |    2 4.130269e-05|  
| 13 |    chief execut offic |    2 4.130269e-05|  
| 14 |   said statement sinc |    2 4.130269e-05|  
| 15 |        thing start go |    2 4.130269e-05|  
| 16 |        mayb just made |    2 4.130269e-05|  
| 17 |compact fluoresc light |    2 4.130269e-05|  
| 18 |       cell phone call |    2 4.130269e-05|  
| 19 |   discuss around issu |    2 4.130269e-05|  
| 20 |        next week look |    2 4.130269e-05|  
  
  
```  
df3top <- head(df3,20)
p <- ggplot(df3top, aes(x=reorder(ngrams, freq), y=freq))
p <- p + geom_bar(stat="identity")
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))+
        xlab("3-gram")+
        ylab("Frequency")
p

```
  
