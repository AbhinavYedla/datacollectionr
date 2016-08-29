######################################################################################################
#                                     Wikipedia Top 1000 Pages Scrape                                #
######################################################################################################
#'
#' @description
#' Get Top 1000 wikipedia pages given the project and date
#'
#' @param
#' None
#' @return
#' One file is created for each country
#'
#' @details
#' Its not a function. This is data collection code based on the WikiEdits function. Parallel programming
#' is used to increase the processing power
#'
#' @examples
#'
#'
#' @author
#' Abhinav Yedla \email{abhinavyedla@gmail.com}
#'
#' @references
#'
#' @keywords
#' Parallel programming, Wikipedia Page Edits
#'
#' @seealso
#' \code{\link{}}
#'
#' @export

#Checking library
#install.packages("xlsx")
#write code to add only date to as many rows as required  (1000 or 999)
library(xlsx)

library(jsonlite)
wb <- createWorkbook()



sheet <- createSheet(wb, sheetName = "Wikipedia Top 1000")

totalDays <- as.numeric(Sys.Date() - as.Date("2016-01-01"))

addDataFrame(
  list("Page Title", "Views", "Rank", "Date"),
  sheet,
  col.name = FALSE,
  row.name = FALSE
)

for (i in 1 : totalDays) {
  date <- Sys.Date() - i
  dateFormatted <- format(date, format = "%Y%m%d")
  data <- wikiTop1000PerDay(dateFormatted)

  data<- data[[1]][6]


 df<- as.data.frame( data$articles[1])


  addDataFrame(df
   ,
    sheet,
    col.names = FALSE,
    row.names = FALSE,
    startRow = ( (i-1) * 1000) + 2,
    startColumn = 1
  )

  addDataFrame(
    rep(date, 1000),
    sheet,
    col.names = FALSE,
    row.names = FALSE,
    startRow = ((i-1) * 1000) + 2,
    startColumn = 4
  )

 saveWorkbook(wb, "WikiPediaTop1000_2016.xlsx")
}
saveWorkbook(wb, "WikiPediaTop1000_2016.xlsx")

###############################

wb <- createWorkbook()
sheet <- createSheet(wb, sheetName = "Wikipedia Top 1000")

endDay <- as.Date("2015-12-31")
totalDays <- as.numeric(endDay - as.Date("2015-07-01"))

addDataFrame(
  c("Page Title", "Views", "Rank", "Date"),
  sheet,
  col.name = FALSE,
  row.name = FALSE
)


for (i in 87:totalDays) {
  date <- endDay - i
  dateFormatted <- format(date, format = "%Y%m%d")
  data <- wikiTop1000PerDay(dateFormatted)



  data<- data[[1]][6]


  df<- as.data.frame( data$articles[1])


  addDataFrame(df
               ,
               sheet,
               col.names = FALSE,
               row.names = FALSE,
               startRow = ( i * 1000) + 2,
               startColumn = 1
  )

  addDataFrame(
    rep(date, 1000),
    sheet,
    col.names = FALSE,
    row.names = FALSE,
    startRow = (i * 1000) + 2,
    startColumn = 4
  )

  saveWorkbook(wb, "WikiPediaTop1000_2015.xlsx")
}

saveWorkbook(wb, "WikiPediaTop1000_2015.xlsx")
