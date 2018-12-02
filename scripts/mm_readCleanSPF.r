readCleanSPF <- function(){
  
  ## Import necessary packages
  lubripack("readr", "dplyr", "tidyr")
  
  ## Load SPARE PARTS FOLLOWUP Dataset
  ## This dataset will help complete the missing MPNs
  SPF <- read_csv("./srcData/SAP_SPARES_FOLLOWUP.csv", 
      col_types = cols(CIE = col_skip(), `CLASS DESCRIPTION` = col_skip(), 
          `CLASS ID` = col_skip(), `COEMF REQUEST#` = col_skip(), 
          COMMENTS = col_skip(), LENGTH = col_skip(), 
          `Material Group` = col_skip(), `PCMC#` = col_skip(), 
          `Part# found in SAP Desc` = col_skip(), 
          RESP = col_skip(), `SAP PARTS DESCRIPTION EN` = col_skip(), 
          `SAP PARTS DESCRIPTION FR` = col_skip() 
          ))
  SPF <- SPF[SPF$STATUS == "PROD",]
  ## Correct material numbers that are duplicated
  SPF$`SAP#`[SPF$`VENDOR PART #` == "104-C30D22"] = NA
  SPF$`SAP#`[SPF$`VENDOR PART #` == "1492-JG4"] = "90013975"
  SPF$`SAP#`[SPF$`VENDOR PART #` == "RB14-516X"] = "90012130"
  ## Duplicate entry with no distinction
  dupe90017833 <- grep("90017833", SPF$`SAP#`)
  SPF$`SAP#`[dupe90017833[2]] = NA
  rm(dupe90017833)
  
  ## remove entries which have no SAP#
  NAs <- nrow(SPF[SPF$`SAP#` == "#N/A",])
  NAs <- NAs + nrow(SPF[is.na(SPF$`SAP#`),])
  print(paste(NAs,
              " SPF records without SAP#",
              sep="")
        )
  SPF <- SPF[!SPF$`SAP#` == "#N/A",]
  SPF <- SPF[!is.na(SPF$`SAP#`),]
  
  ## Remove entries which has missing vendor information
  NAs <- nrow(is.na(SPF$VENDOR))
  print(paste(NAs,
              " SPF records without Mfr name",
              sep="")
  )
  SPF <- SPF[!is.na(SPF$VENDOR),]
  NAs <- sum(as.numeric(is.na(SPF$VENDOR)))
  print(paste(NAs,
              " SPF records without Mfr part#",
              sep="")
  )
  SPF <- SPF[!is.na(SPF$`VENDOR PART #`),]
  
  ## Normalize Vendor name columns
  SPF$VENDOR <- normVendor(SPF$VENDOR)

  ## Split Vendor names on first space
  SPF <- separate(data = SPF,
                  col = VENDOR,
                  into = c("VENDOR1", "VENDOR2"),
                  remove = F, fill="right")
  
  
  ## Must check if any duplicates remaining
  grpSPF <- group_by(SPF, `SAP#`) %>% summarise(length(VENDOR))
  colnames(grpSPF) = c("STRNO", "Freq")
  grpSPF <- arrange(grpSPF, desc(Freq))
  print(paste("Number of duplicate SAP#: ",
              nrow(grpSPF[grpSPF$Freq>1,]),
              sep=""
              )
        )
  if(nrow(grpSPF[grpSPF$Freq>1,]) > 0){
    print(SPF[SPF$`SAP#` == grpSPF[grpSPF$Freq>1,1],])
  }
  return(SPF)
}
