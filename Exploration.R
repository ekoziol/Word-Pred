setwd("D:/Github/SwiftKey_Prediction")
set.seed(42)

require(tm)
require(openNLP)
require(RWeka)
require(slam)

#load("zToken-nospace.RData")
byX <- 50
#bins <- [seq(0,10200, by=byX)]
bins <- c(1,2,3,4,5, 10, 20, 50, 100, 200, 500, 1000, 5000, 10000)
binCounts <- c()
for(b in bins){
  if(b == max(bins)){
    binCounts <- c(binCounts, length(findFreqTerms(zToken, lowfreq = b)))
  }
  else{
    binCounts <- c(binCounts, length(findFreqTerms(zToken, lowfreq = b, highfreq = bins[match(b,bins)+1])))
  }
}
binFreq <- binCounts / sum(binCounts)
#hist(binFreq)
test <- data.frame(bins)
test$freq <- binFreq
qplot(bins, test$freq, test)
#possible R commands
#findAssocs
#Terms(x)
zTokenColSum <- col_sums(zToken)
freq <- sort(table(paste(zTokenColSum, zTokenColSum)), decreasing = T)
freqProb <- freq/sum(freq)