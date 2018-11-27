source("https://raw.githubusercontent.com/FireFighter1017/COEMF/master/funcs/lubripack.r")
source("https://raw.githubusercontent.com/FireFighter1017/COEMF/master/MasterData/funcs/normVendor.r")
source("https://raw.githubusercontent.com/FireFighter1017/COEMF_MPN/master/scripts/mm_matchToZ011.r")
lubripack("readr", "dplyr", "tidyr", "stringdist")

## Read mappings
mapProb <- read.csv("./cache/SAPMpnMappingsFrequency.csv",
                    encoding="UTF-8")

## Read New Materials to process

# Read list of files to process
newDir <- "./srcData/newMat/"
files <- list.files(newDir)
# Create completed folder that will serve as bucket 
# for files that have been processed
completeDir <- "./srcData/complete/"
if(!dir.exists(completeDir)) dir.create(completeDir)

# Cleanup environment
rm(newFile)

# Process each file
for(filename in files){
  # execute function that will process the materials and generate the output
  newFile <- read.csv(paste(newDir, filename, sep=""), encoding="UTF-8")
  colnames(newFile)[1] <- "MATNR"
  newFile <- newFile[,c("MATNR", "MAKTX_EN", "MAKTX_FR", "MFRNR", "MFRPN")]
  newFile$normVendors <- normVendor(newFile$MFRNR)
  mappedVendors <- left_join(newFile, mapProb, by=c("normVendors"="VendorNames"))
  
  ## Filter those that did not find a match
  if(sum(is.na(mappedVendors$Z011VendorNo)) > 0){
    unmapd <- mappedVendors[is.na(mappedVendors$Z011VendorNo),]
    unmapd <- unmapd %>% group_by(MFRNR) %>% summarize(n=n())
    ## Try to match them using Levenshtein
    matchResults <- matchToZ011(unmapd$MFRNR)
    View(cbind(matchResults, unmapd))
    write_csv(cbind(matchResults, unmapd), 
              paste("./srcData/complete/unmapped_", 
                    filename, 
                    sep="")
              )
  }
  
  ## Write those of which a match was found
  write_csv(mappedVendors,
            paste("./srcData/complete/mapped_",
                  filename,
                  sep="")
            )
  
}

unMapped <- rbind(read_csv("srcData/complete/unmapped_Copy of 08_SPARE_PARTS_1715_V682.csv"),
                  read_csv("srcData/complete/unmapped_Copy of 08_SPARE_PARTS_2771_V651.csv")
)
dist <- stringdist(unMapped$MFRNR, mapProb, method='jw')
