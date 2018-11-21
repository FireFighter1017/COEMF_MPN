source("https://raw.githubusercontent.com/FireFighter1017/COEMF/master/funcs/lubripack.r")
source("https://raw.githubusercontent.com/FireFighter1017/COEMF_MPN/master/scripts/mm_readCleanUtopia.r")
source("https://raw.githubusercontent.com/FireFighter1017/COEMF_MPN/master/scripts/mm_readCleanSPF.r")
source("https://raw.githubusercontent.com/FireFighter1017/COEMF/master/MasterData/funcs/normVendor.r")
source("https://raw.githubusercontent.com/FireFighter1017/COEMF_MPN/master/scripts/UtopiaStats.r")
source("https://raw.githubusercontent.com/FireFighter1017/COEMF_MPN/master/scripts/mm_matchToZ011.r")

# Read SAP Data with MPN matches
source("https://github.com/FireFighter1017/COEMF_MPN/blob/master/scripts/mm_mpn_determination.r")

## From the SAP object, create a list of mappings from possible vendors 
## to Z011 vendors from past matches.

# Make a table for Utopia Manufacturer/vendor
UtopiaMV <- SAP[!is.na(SAP$`MANUFACTURER/VENDOR`) & !is.na(SAP$Manufacturer),
                c("Manufacturer", "MANUFACTURER/VENDOR")]
colnames <- c("Z011VendorName", "VendorNames")

# Make a table for Utopia Brands
UtopiaBrand <- SAP[!is.na(SAP$`BRAND`) & !is.na(SAP$Manufacturer),
                c("Manufacturer", "BRAND")]
colnames <- c("Z011VendorName", "VendorNames")

# Make a table for SPF vendor
SPFVendors <- SAP[!is.na(SAP$`VENDOR`) & !is.na(SAP$Manufacturer),
                c("Manufacturer", "VENDOR")]
colnames <- c("Z011VendorName", "VendorNames")

# Add all tables together and compile frequencies
mapFreq <- rbind(UtopiaMV, UtopiaBrand, SPFVendors)
