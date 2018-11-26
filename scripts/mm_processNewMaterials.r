source("https://raw.githubusercontent.com/FireFighter1017/COEMF/master/funcs/lubripack.r")
source("https://raw.githubusercontent.com/FireFighter1017/COEMF/master/MasterData/funcs/normVendor.r")
lubripack("readr", "dplyr", "tidyr")

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
  newFile <- read.csv(paste(newDir, filename, sep=""), encoding="UTF-8")
  colnames(newFile)[1] <- "MATNR"
  newFile <- newFile[,c("MATNR", "MAKTX_EN", "MAKTX_FR", "MFRNR", "MFRPN")]
  newFile$normVendors <- normVendor(newFile$MFRNR)
  mappedVendors <- left_join(newFile, mapProb, by=c("normVendors"="VendorNames"))
  # execute function that will process the materials and generate the output
  View(unique(mappedVendors$normVendors[is.na(mappedVendors$Z011VendorNo)]))
  mappedVendors$Z011VendorNo[mappedVendors$MFRNR=="AB" & grep("^1469", mappedVendors$MFRPN)] == 50004
}
