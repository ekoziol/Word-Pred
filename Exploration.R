setwd("D:/Github/SwiftKey_Prediction")

require(tm)
require(openNLP)
#load in the english blog data
data_blogs = readLines("Raw_Data/en_US/en_US.blogs.txt")
data_twitter=readLines("Raw_Data/en_US/en_US.twitter.txt")
data_news=readLines("Raw_Data/en_US/en_US.news.txt")
profanity <- read.csv("ProfanityWords.csv", header=FALSE)
profanity <- profanity$V1

zdata  <- Corpus(DirSource("D:/Github/SwiftKey_Prediction/Raw_Data/en_US/", encoding="UTF-8"), readerControl = list(language="en_US"))
#zdata  <- Corpus(DirSource("D:/Github/SwiftKey_Prediction/Raw_Data/en_US/", encoding="UTF-8"), readerControl = list(language="en_US"))
zdata <- tm_map(zdata, stripWhitespace)
zdata <- tm_map(zdata, content_transformer(tolower))