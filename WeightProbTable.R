ProbabilityTable[length(strsplit(ProbabilityTable$firstWord, " ")[[1]]) == 1,"V1"] <- 
  ProbabilityTable[length(strsplit(ProbabilityTable$firstWord, " ")[[1]]) == 1,"V1"] * 0.1

ProbabilityTable[length(strsplit(ProbabilityTable$firstWord, " ")[[1]]) == 2,"V1"] <- 
  ProbabilityTable[length(strsplit(ProbabilityTable$firstWord, " ")[[1]]) == 2,"V1"] * 0.4

ProbabilityTable[length(strsplit(ProbabilityTable$firstWord, " ")[[1]]) == 3,"V1"] <- 
  ProbabilityTable[length(strsplit(ProbabilityTable$firstWord, " ")[[1]]) == 3,"V1"] * 0.6

save(ProbabilityTable, file="ProbabilityTable.rds")