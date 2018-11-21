source("https://raw.githubusercontent.com/FireFighter1017/COEMF/master/funcs/lubripack.r")
source("https://raw.githubusercontent.com/FireFighter1017/COEMF_MPN/master/scripts/mm_readCleanUtopia.r")
source("https://raw.githubusercontent.com/FireFighter1017/COEMF_MPN/master/scripts/mm_readCleanSPF.r")
source("https://raw.githubusercontent.com/FireFighter1017/COEMF/master/MasterData/funcs/normVendor.r")
source("https://raw.githubusercontent.com/FireFighter1017/COEMF_MPN/master/scripts/UtopiaStats.r")
source("https://raw.githubusercontent.com/FireFighter1017/COEMF_MPN/master/scripts/mm_matchToZ011.r")

## Read Utopia Data
Utopia <- readCleanUtopia()

## Read Spare Parts Followup Data
SPF <- readCleanSPF()

## Reassign missing Manufacturer/Vendor values from SPF
UtopiaStats(Utopia)
UtopiaComplete <- full_join(Utopia, SPF,  by=c("MATERIAL_NUMBER" = "SAP#"))
potential <- is.na(UtopiaComplete$`FinalVendorName`)
UtopiaComplete$`FinalVendorName`[potential] = 
  UtopiaComplete$VENDOR[potential]
UtopiaStats(UtopiaComplete)

## From UtopiaComplete, find matching Z011 Vendor
matchResults <- matchToZ011(UtopiaComplete$`FinalVendorName`)
UtopiaComplete$Z011.VENDOR <- matchResults$VENDOR
UtopiaComplete$Z011.NAME <- matchResults$NAME
UtopiaComplete$Z011.dist <- matchResults$dist

## UtopiaComplete now contains possible matched Vendor names as well as vendor no.

## Though, some of these entries have suspicious matches that need to be investigated
suspicious <- arrange(UtopiaComplete[UtopiaComplete$Z011.dist>0,], desc(Z011.dist))
suspicious <- suspicious[!is.na(suspicious$Z011.dist),]
View(suspicious)

mpnToSAP <- UtopiaComplete[!is.na(UtopiaComplete$Z011.NAME),]
## Read materials from SAP
SAP <- read_excel("~/Analytics/DataCleansing/srcData/IH09.xlsx")

## Take a look at some stats about SAP data
SAPMatStats(SAP, mpnToSAP)

## Filter those that have no MPN
#SAP <- SAP[is.na(SAP$`Mfr Part Number`),]
## Filter those that found an MPN in UtopiaComplete
#SAP <- SAP[SAP$Material %in% mpnToSAP$MATERIAL_NUMBER,]
## Fill Vendor No.
SAP <- full_join(SAP, mpnToSAP, c("Material" = "MATERIAL_NUMBER"))
vendorMissing <- is.na(SAP$Manufacturer)
SAP$Manufacturer[vendorMissing] <- SAP$Z011.VENDOR[vendorMissing]

## Fill Part #No.
  # Find records where MPN is missing in SAP
  MPNIsMissing <- is.na(SAP$`Mfr Part Number`)
  # Find records where SPF can fill MPN information
  fromSPF <- !is.na(SAP$`VENDOR PART #`) & MPNIsMissing
  # Find records where SPF can't fill and Utopia can
  fromUtopia <- is.na(SAP$`VENDOR PART #`) & 
                !is.na(SAP$PART_NUMBER) & 
                MPNIsMissing
  
  ## Fill using SPF
  # Normalize parts no. from SPF
  SAP$`VENDOR PART #` <- normParts(SAP$`VENDOR PART #`)
  # Copy parts no. from SPF to SAP
  SAP$`Mfr Part Number`[fromSPF] <- SAP$`VENDOR PART #`[fromSPF]
  
  ## Fill using Utopia
  # Normalize parts no. from Utopia
  SAP$PART_NUMBER <- normParts(SAP$PART_NUMBER)
  # Copy parts no. from Utopia to SAP
  SAP$`Mfr Part Number`[fromUtopia] <- SAP$PART_NUMBER[fromUtopia]

## Let's look at some statistics  
SAPMatStats(SAP, mpnToSAP)

## Select records which had no MPN information
mpnLoad <- SAP[MPNIsMissing & !is.na(SAP$Manufacturer),c("Material","Manufacturer","Mfr Part Number")]

# Uncomment this line if a new MPN load file needs to be generated from this
#### write_csv(mpnLoad, "~/Analytics/DataCleansing/MPN_LOAD_2.CSV")



