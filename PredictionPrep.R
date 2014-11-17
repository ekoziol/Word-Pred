set.seed(42) #<- choose wisely!

#library(stylo)

data_blogs = readLines("Raw_Data/en_US/en_US.blogs.txt")
data_twitter=readLines("Raw_Data/en_US/en_US.twitter.txt")
data_news=readLines("Raw_Data/en_US/en_US.news.txt")

SampleData <- function(dataset, rate)
{
  return(dataset[as.logical(rbinom(length(dataset),1,rate))])
}

SD <- c(SampleData(data_blogs, 0.1),SampleData(data_twitter, 0.1),SampleData(data_news, 0.1))

remove(data_blogs, data_news, data_twitter)

profanity <- read.csv("ProfanityWords.csv", header=FALSE)
profanity <- profanity$V1


SD1 <- tolower(SD)
#remove profanity
SD1 <- gsub(paste(profanity, collapse='|'), " ", SD1)
#collapse all ' to join words
SD1 <- gsub("'", "", SD1)
#turn all characters not in the alphabet or a space into a space
SD1 <- gsub("[^a-z ]", " ", SD1) 
#collapse all multiple spaces into one space
SD1 <- gsub(" {2,}", " ", SD1)

#4 gram tokenizer
#size4 <- unlist(lapply(extended[grep("[^ ]*[aeiouyAEIOUY]+[^ ]* [^ ]*[aeiouyAEIOUY]+[^ ]* [^ ]*[aeiouyAEIOUY]+[^ ]* [^ ]*[aeiouyAEIOUY]+[^ ]*", 
#extended)], function(x) make.ngrams(txt.to.words(x, splitting.rule = "[ \t\n]+"), ngram.size = 4)))

#load libraries
library(stylo)
library(data.table)

#create functions
findLastWord <- function(x){
  y <- unlist(strsplit(x, " "))
  return(y[length(y)])
}

findFirstWord <- function(x){
  y <- unlist(strsplit(x, " "))
  return(paste(y[1:length(y)-1], collapse=" "))
}

tokenize <- function(text, sizeX){
  grepGrams <- c()
  for(i in 1:sizeX){
    grepGrams <- c(grepGrams, "[^ ]*[aeiouyAEIOUY]+[^ ]*")
  }
  grepGrams <- paste(grepGrams, collapse = " ")
  
  tokens <- unlist(lapply(text[grep(grepGrams, text)], 
                          function(x) make.ngrams(txt.to.words(x, splitting.rule = "[ \t\n]+"), ngram.size = sizeX)))
  
  return(tokens)
}

#######################

#set play text
catHat <- "the cat in the hat was a fat cat in the hat on the mat"

#create tokens
size2 <- tokenize(SD1, 2)

#create data.table with all tokens
ngramTable <- data.table(size2)
setnames(ngramTable,"size2", "ngram")

#create new data table composed of beginning of ngram and last word of ngram
ngram2 <- data.table(unlist(lapply(ngramTable$ngram, findFirstWord)))
setnames(ngram2, "V1", "firstWord")
ngram2$lastWord <- unlist(lapply(ngramTable$ngram, findLastWord))

#create word frequency table from ngram2
theTable <- table(ngram2)
theTable <- sweep(theTable, 1, rowSums(theTable), "/")
#print(theTable)