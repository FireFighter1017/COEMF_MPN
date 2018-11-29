mm_addVendorToModel <- function(name, Z011No, freq, alias){
  # Updates the model based on mapping received
  #
  # Args:
  #   name:   Z011 Vendor name to map
  #   Z011No:     Z011 Vendor number to map
  #   freq:   Number of observations in current sample
  #   alias:  Vendor name used as alias
  #
  # Returns:
  #   nothing
  
  
  # Bootstrapping
  source("https://raw.githubusercontent.com/FireFighter1017/COEMF/master/funcs/lubripack.r")
  source("https://raw.githubusercontent.com/FireFighter1017/COEMF/master/MasterData/funcs/normVendor.r")
  lubripack("readr", "dplyr", "tidyr", "stringdist")
  
  # Read model
  mapProb <- read.csv("./cache/SAPMpnMappingsFrequency.csv",
                      encoding="UTF-8",
                      stringsAsFactors=FALSE)
  
  # Update mappings statistics 
  # (N, prob, weightedScore)
  
  ## filter on vendor mappings other than the one received
  vendorAliases <- mapProb$Z011VendorNo==Z011No & !(normVendor(mapProb$VendorNames)==normVendor(alias))
  
  if(nrow(mapProb[vendorAliases,])>0){
    ## adjust N, prob for existing mappings
    N <- mapProb$N[vendorAliases][1] + freq
    mapProb$N[vendorAliases] <- 
    mapProb$prob[vendorAliases] <- mapProb$n[vendorAliases] / mapProb$N[vendorAliases]
    mapProb$weightedScore[vendorAliases] <- mapProb$prob[vendorAliases] * mapProb$weight[vendorAliases]
  }

  mapExists <- nrow(mapProb[((mapProb$Z011VendorNo == Z011No) & (mapProb$Z011VendorName == name) & (mapProb$VendorNames == alias)
                           ),]
                    ) > 0
  
  if(mapExists){
    
    ## If mappings exists, we must update its statistics
    updMap <- mapProb[mapProb$Z011VendorNo        == Z011No & 
                      mapProb$Z011VendorName      == name &
                      mapProb$VendorNames         == alias,
                      ]
    updMap$n <- updMap$n + freq
    updMap$prob <- updMap$n/updMap$N
    updMap$N <- updMap$N + freq
    updMap$weightedScore <- updMap$weight * updMap$prob
    mapProb[mapProb$Z011VendorNo==Z011No & 
            mapProb$Z011VendorName==name &
            mapProb$VendorNames==alias,] <- updMap
    
  }else{
  
    ## NEW MAPPING
    ## Set n, weight, prob and weightedScsore for new mapping
    newMap <- mapProb[1,]
    newMap$Z011VendorNo <- Z011No
    newMap$Z011VendorName <- name
    newMap$VendorNames <- alias
    newMap$n <- freq
    dist <- unlist(adist(name, newMap$Z011VendorName))
    newMap$weight <- if_else(dist==0, 1, 1/dist)
    newMap$N <- freq
    newMap$prob <- newMap$n/newMap$N
    newMap$weightedScore <- newMap$weight * newMap$prob
    mapProb <- rbind(mapProb, newMap)
    
  }
  write_csv(mapProb, "./cache/SAPMpnMappingsFrequency.csv")
  
}