library(data.table)

ProbabilityTable <- load("ngramsOver1.rds")
ProbabilityTable <- ngramsOver1
ProbabilityTable <- data.table(ProbabilityTable)

ProbabilityTable$V1 <- as.numeric(ProbabilityTable$V1)

setkey(ProbabilityTable, "firstWord")
X <- ProbabilityTable[, list(SUM=sum(V1)), by=key(ProbabilityTable)] 
Probs <- ProbabilityTable[X, list(lastWord, V1, V1/SUM)]
Probs <- ProbabilityTable[X, list(firstWord, lastWord, log(1+V1/SUM))]

ProbabilityTable <- Probs
setnames(ProbabilityTable, "V3", "V1")

ProbabilityTable[length(strsplit(ProbabilityTable$firstWord, " ")[[1]]) == 1,]$V1 <- 
  ProbabilityTable[length(strsplit(ProbabilityTable$firstWord, " ")[[1]]) == 1,]$V1 * 0.05

ProbabilityTable[length(strsplit(ProbabilityTable$firstWord, " ")[[1]]) == 2,]$V1 <- 
  ProbabilityTable[length(strsplit(ProbabilityTable$firstWord, " ")[[1]]) == 2,]$V1 * 0.15

ProbabilityTable[length(strsplit(ProbabilityTable$firstWord, " ")[[1]]) == 3,]$V1 <- 
  ProbabilityTable[length(strsplit(ProbabilityTable$firstWord, " ")[[1]]) == 3,]$V1 * 0.7

save(ProbabilityTable, file="ProbabilityTable.rds")