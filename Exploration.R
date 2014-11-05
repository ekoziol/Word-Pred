setwd("D:/Github/SwiftKey_Prediction")

require(tm)
#load in the english blog data
data_blogs = readLines("Raw_Data/en_US/en_US.blogs.txt")
data_twitter=readLines("Raw_Data/en_US/en_US.twitter.txt")
data_news=readLines("Raw_Data/en_US/en_US.news.txt")
crps  <- Corpus(DirSource("D:/Github/SwiftKey_Prediction/Raw_Data/en_US/", encoding="UTF-8"), readerControl = list(language="en_US"))