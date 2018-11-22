normVendor <- function(VENDOR){
  ## Convert VENDOR into normalized value
    # Uppercase
  VENDOR <- toupper(VENDOR)
    # Remove anything that is not a letter or a space
  VENDOR <- gsub("[^a-zA-Z[:space:][:digit:]]", "", VENDOR)
    # Remove carriage returns
  VENDOR <- gsub("\\n", "", VENDOR)
  VENDOR[VENDOR=="TB"] <- "THOMAS & BETTS"
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
  return(PART)
}