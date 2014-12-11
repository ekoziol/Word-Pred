set.seed(42) #<- choose wisely!
library(plyr)
library(stylo)

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
SD1 <- gsub("-", "", SD1)
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

#create tokens
unigrams <- tokenize(SD1, 1)
unigramTable <- sort(table(unigrams), decreasing=T)
cutoff <- quantile(unigramTable, 0.95) #originally 0.95
unigramTop <- names(unigramTable[unigramTable > cutoff])

uniqueWords <- names(unigramTable)
save(uniqueWords, file="uniqueWords.rds")

SD2 <- SD1

for(i in 1:length(SD2)){
  temp <- strsplit(SD2[i], " ")
  temp[[1]][!(temp[[1]] %in% unigramTop)] <- "<UNK>"
  SD2[i] <- paste(temp[[1]], collapse = " ")
}


size2 <- tokenize(SD2, 2)
size3 <- tokenize(SD2, 3)
size4 <- tokenize(SD2, 4)

#create data.table with all tokens
ngramTable <- data.table(size2)
setnames(ngramTable,"size2", "ngram")

#create new data table composed of beginning of ngram and last word of ngram
ngram2 <- data.table(unlist(lapply(ngramTable$ngram, findFirstWord)))
setnames(ngram2, "V1", "firstWord")
ngram2$lastWord <- unlist(lapply(ngramTable$ngram, findLastWord))

#create word frequency table from ngram2
# theTable <- table(ngram2)
# theTable <- sweep(theTable, 1, rowSums(theTable), "/")
#print(theTable)

ngram2ply <- ddply(ngram2,.(firstWord,lastWord),nrow)


ngramToDF <- function(tokens)
{
  ngramTable <- data.table(tokens)
  setnames(ngramTable, names(ngramTable)[1], "ngram")
  
  ngram <- data.table(unlist(lapply(ngramTable$ngram, findFirstWord)))
  setnames(ngram, "V1", "firstWord")
  ngram$lastWord <- unlist(lapply(ngramTable$ngram, findLastWord))
  
  ngramply <- ddply(ngram,.(firstWord,lastWord),nrow)
  
  return(ngramply)
}

ngram3ply <- ngramToDF(size3)
ngram4ply <- ngramToDF(size4)

ngrams <- rbind(ngram2ply, ngram3ply)
ngrams <- rbind(ngrams, ngram4ply)
ngrams <- ngrams[!(ngrams$lastWord == "<unk>"),]

for(w in unique(ngrams$firstWord)){
  wsplit <- strsplit(w, " ")
  wordFactor <- 1
  if(length(wsplit) == 1){
    wordFactor <- 0.1
  }
  else if(length(wsplit) == 2){
    wordFactor <- 0.3
  }
  else{
    wordFactor <- 0.6
  }
  
  ngrams[ngrams$firstWord == w, "V1"] <- log(wordFactor * ngrams[ngrams$firstWord == w, "V1"] /  sum(ngrams[ngrams$firstWord == w, "V1"]))
}

save(ngrams, file = "ProbabilityTable.rds")
##
# size4 <- tokenize(SD1, 4)
# ngramTable4 <- data.table(size4)
# setnames(ngramTable4,"ngram")
# ngram4 <- data.table(unlist(lapply(ngramTable4$ngram, findFirstWord)))
# setnames(ngram4, "V1", "firstWord")
# ngram4$lastWord <- unlist(lapply(ngramTable4$ngram, findLastWord))
# ngram4ply <- ddply(ngram4,.(firstWord,lastWord),nrow)

# for(i in 1:length(sdTest)){
#   temp <- strsplit(sdTest[i], " ")
#   temp[[1]][!(temp[[1]] %in% words)] <- "<UNK>"
#   sdTest[i] <- paste(temp[[1]], collapse = " ")
# }

