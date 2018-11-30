#################################################################
#
# Build a prediction model for vendor names and numbers
#

source("https://raw.githubusercontent.com/FireFighter1017/COEMF/master/funcs/lubripack.r")
lubripack("readr", "dplyr", "tidyr", "stringdist", "foreach")

# Read SAP Data with MPN matches
SAP <- read_csv("./cache/SAP_MAT_MPN.csv")

## From the SAP object, create a list of mappings from possible vendors 
## to Z011 vendors from past matches.

# Make a table for Utopia Manufacturer/vendor
UtopiaMV <- SAP[!is.na(SAP$`MANUFACTURER/VENDOR`) & !is.na(SAP$Manufacturer),
                c("Manufacturer", "Z011.NAME", "MANUFACTURER/VENDOR")]
colnames(UtopiaMV) <- c("Z011VendorNo", "Z011VendorName", "VendorNames")

# Make a table for Utopia Brands
UtopiaBrand <- SAP[!is.na(SAP$`BRAND`) & !is.na(SAP$Manufacturer),
                c("Manufacturer", "Z011.NAME", "BRAND")]
colnames(UtopiaBrand) <- c("Z011VendorNo", "Z011VendorName", "VendorNames")

# Make a table for SPF vendor
SPFVendors <- SAP[!is.na(SAP$`VENDOR`) & !is.na(SAP$Manufacturer),
                c("Manufacturer", "Z011.NAME", "VENDOR")]
colnames(SPFVendors) <- c("Z011VendorNo", "Z011VendorName", "VendorNames")

# Add all tables together and compile frequencies
mappings <- rbind(UtopiaMV, UtopiaBrand, SPFVendors)

# Compile weights of entries based on string distance calculated using osa
# (osa = Optimal string alignment, i.e. restricted Damerau-Levenshtein)

osaDist <- unlist(foreach(i=1:nrow(mappings)) %dopar%
                   unlist(stringdist(mappings$Z011VendorName[i], 
                                mappings$VendorNames[i])
                          )
                 )

mappings$dist <- if_else(osaDist>0, 1/osaDist, 1)


mapFreq <- group_by(mappings, Z011VendorNo, Z011VendorName, VendorNames)
mapFreq <- summarise(mapFreq, n=n(), weight=mean(dist))
mapCount <- group_by(mappings, Z011VendorNo, Z011VendorName)
mapCount <- summarise(mapCount, N=n())
mapProb <- inner_join(mapFreq, mapCount)
mapProb$prob <- mapProb$n/mapProb$N
mapProb$weightedScore <- mapProb$prob * mapProb$weight

View(mapProb)
write_csv(mapProb, "./cache/SAPMpnMappingsFrequency.csv")
