library(readxl)
library(stringi)
library(foreach)
sap_mpn <- read_excel("srcData/SPARE_PARTS_IH09.xlsx")

# scrape mpn number and find pattern
mpn <- "1FT7086-5AF71-1NB0 AB1"




pattern_detection_regex <- function(x, format="regex"){
  getRegexToken <- function(c){
    library(stringi)
    if(stri_detect_regex(c, "[[:alpha:]]")){
      regex_token <- "."
    }
    if(stri_detect_regex(c, "[[:digit:]]")){
      regex_token <- "\\d"
    }
    if(stri_detect_regex(c, "[^[:alnum:]]")){
      if(stri_detect_regex(c, "\\s")){
        regex_token <- "\\s"
      }else{
        regex_token <- paste("\\", c, sep="")
      }
    }
    return(regex_token)
  }
  
  
  getCharacterToken <- function(c){
    library(stringi)
    if(stri_detect_regex(c, "[[:alpha:]]")){
      char_token <- "A"
    }
    if(stri_detect_regex(c, "[[:digit:]]")){
      char_token <- "9"
    }
    if(stri_detect_regex(c, "[^[:alnum:]]")){
      if(stri_detect_regex(c, "\\s")){
        char_token <- " "
      }else{
        char_token <- c
      }
    }
    return(char_token)
  }
  
  if(is.na(x)){
    regex_pattern<-NA
    
  }else{
    regex_pattern <- ""
    token_count <- 0
    previous_token <- ""
    
    foreach(i=1:nchar(x)) %dopar% {
      c <- substr(x, i, i)
      
      if(format=="regex"){
        current_token <- getRegexToken(c)  
      }else{
        current_token <- getCharacterToken(c)
      }
      

      if(!current_token==previous_token && !i==1){ # On same token, count
        
        if(token_count==1){ 
          regex_pattern <- paste(regex_pattern, current_token, sep="")
        }else{
          regex_pattern <- paste(regex_pattern, "{", token_count, "}", current_token, sep="")
        }
        token_count <- 0
      }
      if(i==1){ #First token
        regex_pattern <- current_token
      }

      token_count <- token_count + 1
      if(i==nchar(x) && !token_count==1){ #Last token quantifier if necessary
        regex_pattern <- paste(regex_pattern, "{", token_count, "}", sep="")
      }      
      previous_token <- current_token
    }

  }
  return(regex_pattern)
}

cl <- parallel::makeCluster(4)
doParallel::registerDoParallel(cl)
patterns <- unlist(sapply(sap_mpn$`Mfr Part Number`, pattern_detection_regex, USE.NAMES=F))
  