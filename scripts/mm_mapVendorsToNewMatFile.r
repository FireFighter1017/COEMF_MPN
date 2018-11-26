mm_mapVendorsToNewMatFile <- function(newFile){
  srcVendors <- normVendor(newFile$MFRNR)
  mappedVendors <- matchingVendor(srcVendors)
}