mm_addVendorToModel <- function(name, no, freq){
  ## retreive vendor association from model
  source("https://raw.githubusercontent.com/FireFighter1017/COEMF/master/funcs/lubripack.r")
  source("https://raw.githubusercontent.com/FireFighter1017/COEMF/master/MasterData/funcs/normVendor.r")
  lubripack("readr", "dplyr", "tidyr", "stringdist")
  
  ## Read mappings
  mapProb <- read.csv("./cache/SAPMpnMappingsFrequency.csv",
                      encoding="UTF-8")
  ## filter on vendor mappings
  vendorMaps <- mapProb$Z011VendorNo==no
  ## adjust N, prob for existing mappings
  mapProb$N[vendorMaps] <- mapProb$N[vendorMaps] + freq
  mapProb$prob[vendorMaps] <- mapProb$n[vendorMaps] / mapProb$N[vendorMaps]
  
  ## Set n, weight, prob and weightedCsore for new mapping
  newMap <- mapProb[vendorMaps,][1,]
  newMap$VendorNames <- normVendor(name)
  newMap$n <- freq
  dist <- unlist(stringdist(name, newMap$Z011VendorName))
  newMap$weight <- if_else(dist==0, 1, 1/dist)
  newMap$prob <- newMap$n/newMap$N
  newMap$weightedScore <- newMap$weight * newMap$prob
  mapProb <- rbind(mapProb, newMap)
  
  write_csv(mapProb, "./cache/SAPMpnMappingsFrequency.csv")
  
}