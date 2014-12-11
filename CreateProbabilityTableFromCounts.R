library(data.table)

ProbabilityTable <- load("ngramsOver1.rds")
ProbabilityTable <- ngramsOver1
ProbabilityTable <- data.table(ProbabilityTable)

setkey(ProbabilityTable, "firstWord")
X <- ProbabilityTable[, list(SUM=sum(V1)), by=key(ProbabilityTable)] 
Probs <- ProbabilityTable[X, list(lastWord, V1, V1/SUM)]
Probs <- ProbabilityTable[X, list(firstWord, lastWord, log(1+V1/SUM))]

ProbabilityTable[length(strsplit(ProbabilityTable$firstWord, " ")[[1]]) == 1,]$V1 <- 
  ProbabilityTable[length(strsplit(ProbabilityTable$firstWord, " ")[[1]]) == 1,]$V1 * 0.1

ProbabilityTable[length(strsplit(ProbabilityTable$firstWord, " ")[[1]]) == 2,]$V1 <- 
  ProbabilityTable[length(strsplit(ProbabilityTable$firstWord, " ")[[1]]) == 2,]$V1 * 0.4

ProbabilityTable[length(strsplit(ProbabilityTable$firstWord, " ")[[1]]) == 3,]$V1 <- 
  ProbabilityTable[length(strsplit(ProbabilityTable$firstWord, " ")[[1]]) == 3,]$V1 * 0.6

save(ProbabilityTable, file="ProbabilityTable.rds")