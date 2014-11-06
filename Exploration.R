setwd("D:/Github/SwiftKey_Prediction")
set.seed(42)

require(tm)
require(openNLP)
#load in the english blog data
data_blogs = readLines("Raw_Data/en_US/en_US.blogs.txt")
data_twitter=readLines("Raw_Data/en_US/en_US.twitter.txt")
data_news=readLines("Raw_Data/en_US/en_US.news.txt")

#sample 1% of the data from each data set then combine together
SampleData <- function(dataset, rate)
{
  return(dataset[as.logical(rbinom(length(dataset),1,rate))])
}


selectedData <- c(SampleData(data_blogs, 0.1),SampleData(data_twitter, 0.1),SampleData(data_news, 0.1))
selectedData <- gsub("[^a-zA-Z ]", " ", selectedData)
remove(data_blogs, data_news, data_twitter)

#load profanity filter
profanity <- read.csv("ProfanityWords.csv", header=FALSE)
profanity <- profanity$V1

#remove all profanity words
selectedData <- gsub(paste(profanity, collapse='|'), " ", selectedData)

#zdata  <- Corpus(DirSource("D:/Github/SwiftKey_Prediction/Raw_Data/en_US/", encoding="UTF-8"), readerControl = list(language="en_US"))

zdata <- Corpus(VectorSource(selectedData), readerControl = list(language="en_US"))
zdata <- tm_map(zdata, stripWhitespace)
zdata <- tm_map(zdata, content_transformer(tolower))
zToken <- DocumentTermMatrix(zdata)

