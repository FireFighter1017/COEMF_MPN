lubripack <- function(...,silent=TRUE){
  
  #check names and run 'require' function over if the given package is installed
  requirePkg<- function(pkg){if(length(setdiff(pkg,rownames(installed.packages())))==0)
    require(pkg, quietly = TRUE,character.only = TRUE)
  }
  
  packages <- as.vector(unlist(list(...)))
  if(!is.character(packages))stop("No numeric allowed! Input must contain package names to install and load")
  
  if (length(setdiff(packages,rownames(installed.packages()))) > 0 )
    install.packages(setdiff(packages,rownames(installed.packages())),
                     repos = c("https://cran.revolutionanalytics.com/", "http://owi.usgs.gov/R/"))
  
  res<- unlist(sapply(packages, requirePkg))
  
  if(silent == FALSE && !is.null(res)) {cat("\nBellow Packages Successfully Installed:\n\n")
    print(res)
  }
}