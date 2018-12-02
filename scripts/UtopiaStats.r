UtopiaStats <- function(x){
  print(paste("Number of matches between Utopia and SPF: ", 
        nrow(x[x$MATERIAL_NUMBER %in% SPF$`SAP#`,]),
        sep="")
        )
  print(paste("Number of potential fillings in Utopia's Manufacturer/Vendor: ",
              nrow(x[x$MATERIAL_NUMBER %in% SPF$`SAP#` & is.na(x$`MANUFACTURER/VENDOR`),]),
              sep=""
              )
        )
  print(paste("Number of missing values in Utopia's Manufacturer/Vendor: ",
              nrow(x[is.na(x$`MANUFACTURER/VENDOR`),]),
              sep=""
              )
        )
  print(paste("Number of missing values in Utopia's FinalVendorName: ",
              sum(as.numeric(is.na(x$FinalVendorName))),
              sep=""
              )
        )
}

SAPMatStats <- function(x, y){
  print(paste("Number of materials : ", 
        nrow(x),
        sep="")
        )
  print(paste("Number of material no. matched : ",
              nrow(x[x$Material %in% y$MATERIAL_NUMBER,]),
              sep=""
              )
        )
  print(paste("Number of missing MPN : ",
              nrow(x[is.na(x$`Mfr Part Number`),]),
              sep=""
              )
        )
  print(paste("Number of records with a Manufacturer but missing Part# :",
              nrow(x[!is.na(x$Manufacturer) & is.na(x$`Mfr Part Number`),]),
              sep=""
              )
        )
  print(paste("Number of records with a Part# but missing Manufacturer :",
              nrow(x[is.na(x$Manufacturer) & !is.na(x$`Mfr Part Number`),]),
              sep=""
              )
        )
  tmp <- left_join(x, y, c("Material" = "MATERIAL_NUMBER"))
  print(paste("Number of matching MPN found: ",
              nrow(tmp[!is.na(tmp$Z011.VENDOR) & is.na(tmp$Manufacturer),]),
              sep=""
              )
        )
}