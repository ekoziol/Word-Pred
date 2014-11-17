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
size2 <- tokenize(catHat, 2)

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
print(theTable)