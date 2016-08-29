1.    Drop if pagename == missing

2.    Drop if pagename  == -3.    Create new variable called mastercodes. We’re going to use this as a filter variable (keep if , drop if , etc.) in the analysis. Let’s start filling that variable as follows:a.    1 = Wikipedia (code all Wikipedia:…) to 1 so that we can remove the Wikipedia related content (how -
                                                                                                                                                                                                                                                                                                                       to and such).

b.    2 = User (code all User:…) to a 2.

c.     3 = Country (use you country list to search page names for our list of countries). This is the one I am most interested in for now.

d.    4 = Dates (code all dates [April_11]) to a 4.

library(readxl)

data_2016 <- read_excel("WikiPediaTop1000_2016.xlsx")
data_2016_tidy <- data_2016[!is.na(data_2016$`Page Title`) , ]


data_2016_tidy$masterCode <- 0

data_2016_tidy$masterCode[grep(
  "Wikipedia|Main_Page",
  ignore.case = TRUE,
  perl = TRUE,
  x = data_2016_tidy$`Page Title`
)] <- 1

data_2016_tidy$masterCode[grep(
  "user:",
  ignore.case = TRUE,
  perl = TRUE,
  x = data_2016_tidy$`Page Title`
)] <- 2

countryList <-
  read.table("CountryList.txt",
             header = FALSE,
             stringsAsFactors = FALSE)

countryList[195, ] <- "Burma"

#countryList<-as.character(unlist(countryList))

#data_2016_tidy$masterCode[grep(paste(countryList,collapse = "|"),fixed = TRUE,x = data_2016_tidy$`Page Title`)] <- 3
counCount <- nrow(countryList)
for (i in 1:counCount) {
  data_2016_tidy$masterCode[data_2016_tidy$`Page Title` == countryList[i, 1]] <-
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


data_2016_tidy$masterCode[grep(paste(months, collapse = "|"),
                              fixed = FALSE,
                             x = data_2016_tidy$`Page Title`)] <- 4

data_2016_tidy$masterCode[grep("\\d{4}", fixed = FALSE, x = data_2016_tidy$`Page Title`)] <-
  4

write.table(data_2016_tidy,"WikipediaTop1000_EN_2016.txt",sep=",",row.names = FALSE)

write.table(data_2016_tidy,"WikipediaTop1000_EN_2016.txt",sep=",",row.names = FALSE)