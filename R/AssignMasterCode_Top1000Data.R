
tidyTop1000Data <- function(dataYear){
  
countryList <- read.delim("countryList.txt",sep="\t",header = FALSE)

totalCountries <- nrow(countryList)

for(i in 1 : totalCountries){
  data_country_lang <- rbind(data_country_lang, wikiPageAllLanguages(countryList[totalCountries,])
}



totalLang <- read.delim("LanguageCodes.txt",sep="\t",header = FALSE)[,3]

countTotalLang <- nrow(totalLang)

for(i in  1 : countTotalLang){
  
  
  data <- read.delim(file = paste0(totalLang[i],"_",dataYear,".txt"),sep="\t",header = FALSE)
  
  data_tidy <- data[!is.na(data$`Page Title`) , ]
  data_tidy$masterCode <- 0
  
  data_tidy$masterCode[grep(
    "Wikipedia|Main_Page",
    ignore.case = TRUE,
    perl = TRUE,
    x = data_tidy$`Page Title`
  )] <- 1
  
  data_tidy$masterCode[grep(
    "user:",
    ignore.case = TRUE,
    perl = TRUE,
    x = data_tidy$`Page Title`
  )] <- 2
  
  countryList_language <- data_country_lang[data_country_lang$'Wikipedia code' == totalLang[countTotalLang],]
  
  countryList <-
    read.table("CountryList.txt",
               header = FALSE,
               stringsAsFactors = FALSE)
  
  #countryList[195, ] <- "Burma"
  
  #countryList<-as.character(unlist(countryList))
  
  #data_tidy$masterCode[grep(paste(countryList,collapse = "|"),fixed = TRUE,x = data_tidy$`Page Title`)] <- 3
  counCount <- nrow(countryList_language)
  for (i in 1:counCount) {
    data_tidy$masterCode[data_tidy$`Page Title` == countryList_language[i, 1]] <-
      3
  }
  
  months <- c(
    "January",
    "February",
    
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  )
  
  
  data_tidy$masterCode[grep(paste(months, collapse = "|"),
                                 fixed = FALSE,
                                 x = data_tidy$`Page Title`)] <- 4
  
  data_tidy$masterCode[grep("\\d{4}", fixed = FALSE, x = data_tidy$`Page Title`)] <-
    4
  
  write.table(file = paste0(totalLang[i],"_",dataYear,"_Tidy.txt"),sep="\t",header = FALSE)
  
  
}