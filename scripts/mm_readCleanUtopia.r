readCleanUtopia <- function(){
  
  ## Import necessary packages
  lubripack("readxl", "dplyr", "tidyr")
  
  ## Load Utopia dataset with MPN extracted
  Utopia <- read_excel("./srcData/Cascades_Master_File_20181029_V1.xlsx",
                       sheet = "Master", 
                       col_types = c("text", "skip", "text", "text", "text",
                                     "text", "text", "text", "skip", "skip", 
                                     "text", "skip", "text")
                       )
  # Normalize vendor name columns
  Utopia$`MANUFACTURER/VENDOR` = normVendor(Utopia$`MANUFACTURER/VENDOR`)
  Utopia$FinalVendorName = normVendor(Utopia$FinalVendorName)
  Utopia$PART_NUMBER = normParts(Utopia$PART_NUMBER)
  # Split Vendor name on spaces
  Utopia <- separate(data = Utopia,
                  col = `MANUFACTURER/VENDOR`, 
                  into = c("VENDOR1", "VENDOR2"), 
                  remove = F)
  
  return(Utopia)
}