matchToZ011 <- function(x){
  lubripack("parallel")
  
  # Function to find closest match
  matchingVendor <- function(v1){
    library(readr)
    library(dplyr)
    source("https://raw.githubusercontent.com/FireFighter1017/COEMF/master/MasterData/funcs/normVendor.r")
    ## Load Z011 suppliers dataset
    Z011 <- read_csv("./srcData/Z011_VENDORS.csv",
                     col_names= c("NAME",
                                  "VENDOR")
                     )
    Z011$NAME <- normVendor(Z011$NAME)
    results <- Z011[agrep(toupper(v1), toupper(Z011$NAME)), c("VENDOR","NAME")]
    results$dist <- as.numeric(t(adist(v1, results$NAME)))
    arrange(results, dist)[1,]
  }
  
  no_cores <- detectCores() - 1
  cl <- makeCluster(no_cores)
  temp <- parSapply(cl, x, FUN=matchingVendor)
  stopCluster(cl)
  
  matchResults <- data.frame(t(temp), row.names=NULL)
  matchResults$VENDOR <- unlist(matchResults$VENDOR)
  matchResults$NAME <- unlist(matchResults$NAME)
  matchResults$dist <- unlist(matchResults$dist)
  return(matchResults)
}