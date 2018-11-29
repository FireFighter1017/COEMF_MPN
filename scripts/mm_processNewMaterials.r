## tODO
## recalculer n, N, weight, prob et weighted Score quand on traite un mapping
## Tester et confirmer le fonctionnement de l'Algorithme 
##   de mise à jour du modèle de prédiction
## Créer une application Shiny ou autre qui pourra être hébergée 
##   dans le cloud ou sur un serveur Cascades et fonctionnelle sur demande

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
  # Read input file having load format to SAP
  newFile <- read.csv(paste(newDir, filename, sep=""), encoding="UTF-8")
  colnames(newFile)[1] <- "MATNR"
  # Select only relevant columns
  newFile <- newFile[,c("MATNR", "MAKTX_EN", "MAKTX_FR", "MFRNR", "MFRPN")]
  # Find matching names in model and join values
  newFile$normVendors <- normVendor(newFile$MFRNR)
  mappedVendors <<- left_join(newFile, mapProb, by=c("normVendors"="VendorNames"))
  
  # For those that did not find a matching model
  # we perform Levenshtein matching with Z011 reference list
  if(sum(is.na(mappedVendors$Z011VendorNo)) > 0){
    unmapd <<- mappedVendors[is.na(mappedVendors$Z011VendorNo),]
    unmapd <<- unmapd %>% group_by(MFRNR) %>% summarize(n=n())
    ## Try to match them using Levenshtein
    matchResults <<- matchToZ011(unmapd$MFRNR)
    unMapped <- cbind(matchResults, unmapd)
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

readMapped <- function(srcDir){
  files <- list.files(srcDir, pattern="^mapped_")
  # Process each file
  for(filename in files){
    mapped <- read.csv(paste(srcDir, filename, sep=""), 
                       encoding="UTF-8",
                       stringsAsFactors=FALSE)
    mapped <- mapped[!is.na(mapped$Z011VendorNo),]
    ## Update model with recent mappings
    for(i in c(1:nrow(mapped))){
      map <- mapped[i,]
      n <- nrow(mapped[mapped$MFRNR==map$MFRNR,])
      mm_addVendorToModel(map$Z011VendorName, 
                          map$Z011VendorNo,
                          n,
                          map$MFRNR
                          )
    }
  }
}

## Once unMapped values are mapped and approved, we can update the model
#mm_addVendorToModel(unMapped$NAME[2,1], 
#                    unMapped$VENDOR[2,2], 
#                    unMapped$n[2,3], 
#                    unMapped$MFRNR[3])

# unMapped <- rbind(read_csv("srcData/complete/unmapped_Copy of 08_SPARE_PARTS_1715_V682.csv"),
#                   read_csv("srcData/complete/unmapped_Copy of 08_SPARE_PARTS_2771_V651.csv")
# )
# dist <- stringdist(unMapped$MFRNR, mapProb, method='jw')
