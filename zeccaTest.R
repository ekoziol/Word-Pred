catHat <- "the cat in the hat was a fat cat in the hat on the mat"
# catHat <- paste("<br>", catHat, "</br>")
onegram <- table(strsplit(catHat, split = " "))


cathatCorp <- Corpus(VectorSource(catHat), readerControl = list(language="en_US", load = TRUE))

library(data.table)

minToken <- 2
maxToken <- 2
library(RWeka)
options(mc.cores=1)
tokened <- function(x) NGramTokenizer(x, Weka_control(min = minToken, max = maxToken))
cathatTDM <- TermDocumentMatrix(cathatCorp, control = list(tokenize = tokened))

inspect(cathatTDM)


#Separate 1-2-3 gram
rawFreq <- rowSums(as.matrix(cathatTDM))
rawFreq

ngram2 <- data.table(word = names(rawFreq), freq = rawFreq)
rm(rawFreq)
ngram2

#The CRUX
ngram2 <- as.data.table(with(ngram2, rep(word, freq)))


temp <- ngram2 #Note rm(temp) later and rm(gram2)
setnames(temp, "V1", "word")

temp$ntl <- sapply(strsplit(temp$word, split=" "), "[", 1)
temp$last <- sapply(strsplit(temp$word, split=" "), "[", 2)

rawTable <- table(temp$ntl, temp$last)
rawTable

#Raw count
sweep(rawTable, 2, onegram, "/")