normVendor <- function(VENDOR){
  ## Convert VENDOR into normalized value
    # Uppercase
  VENDOR <- toupper(trimws(VENDOR))
    # Remove anything that is not a letter or a space
  VENDOR <- gsub("[^a-zA-Z[:space:][:digit:]]", "", VENDOR)
    # Remove carriage returns
  VENDOR <- gsub("\\n", "", VENDOR)
    # Remove invalid entries
  VENDOR[VENDOR==0] = NA
  VENDOR[VENDOR=="TB"] <- "THOMAS & BETTS"
  VENDOR[VENDOR=="SKF CANADA"] <- "SKF"
  VENDOR[grep("^REGAL BELOIT", VENDOR)] <- "REGAL BELOIT"
  VENDOR[grep("^ABB MOTOR", VENDOR)] <- "ABB"
  VENDOR[VENDOR=="NTN BEARING CORP OF CANADA LTD"] <- "NTN"
  VENDOR[grep("MARTIN SPROCKET", VENDOR)] <- "MARTIN SPROCKET & GEAR"
  VENDOR[grep("^REXNORD", VENDOR)] <- "REXNORD"
  VENDOR[VENDOR=="CHEMLINE PLASTICS LIMITED"] <- "CHEMLINE"
  VENDOR[VENDOR=="JDB BEARINGS OF CANADA LTD"] <- "JDB BEARINGS"
  VENDOR[grep("^OSISENSE", VENDOR)] <- "TELEMECANIQUE"
  VENDOR[grep("^YUEQING BETHEL", VENDOR)] <- "YUEQING BETHEL"
  VENDOR[grep("^ADAPTA BEACON", VENDOR)] <- "EDWARDS"
  return(VENDOR)
}

normParts <- function(PART){
  ## Convert VENDOR into normalized value
    # Uppercase
  PART <- toupper(PART)
    # Remove any spaces
  PART <- gsub("[:space:]", "", PART)
    # Remove carriage returns
  PART <- gsub("\\n", "", PART)
    # Remove invalid entries
  PART[PART==0] = NA
  return(PART)
}