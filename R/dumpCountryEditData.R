#############################################################################
#               Tidy Wikipedia Edits Data and dump it to database           #
#############################################################################
#'
#' @description
#' Tidy the data retrieved from WikiEdits function and store it in a
#' relational database and text files.
#'
#' @param continent
#' Which continent data to be stored
#'
#' @return
#' Set of files are created
#'
#' @details
#' One file for each country is created.
#' Changed Burma_(Myanmar) to Myanmar
#  Korea,_North to North_Korea
#  Korea,_South to South_Korea
#'
#' \code{}
#'
#' @examples
#' WikiEditsTidy("North_America")
#'
#' @author
#' Abhinav Yedla \email{abhinavyedla@gmail.com}
#'
#' @references
#'
#' @keywords
#' Wikipedia Page Edits
#'
#' @seealso
#' \code{\link{}}
#'
#' @export


WikiEditsTidy <- function(continent) {
  #Checking library
  if (!require("RMySQL")) {
    print("Trying to install RMySQL")
    install.packages("RMySQL")
    if (require(RMySQL)) {
      print("RMySQL installed and loaded")
    } else {
      stop("Could not install RMySQL")
    }
  }

  #Establishing connection with database
  mydb = dbConnect(
    MySQL(),
    user = 'root',
    password = 'root',
    dbname = 'wikipedia',
    host = '127.0.0.1'
  )

  #Read countrys
  country.list <-
    read.delim(paste0("~/Wiki/Data/", continent, ".txt"), header = FALSE)

  #Read ISO 639-1 and ISO 639-3 language codes defined by Wikipedia
  languageCodes <-
    read.delim(("~/Wiki/Data/LanguageCodes.txt"),
               header = FALSE,
               encoding = "UTF-8")


  count.countries <- nrow(country.list)

  #Replace spcae with _ so to make url
  country.list$V1 <- gsub(" ", "_", country.list$V1, fixed = TRUE)

  #Iterate through country List
  for (i in 1:count.countries) {
    data <-
      read.delim(
        file = paste0("~/wikipagestats/WikiEdits/", country.list[i, 1], ".csv"),
        header = FALSE,
        sep = ",",
        encoding = "UTF-8",
        stringsAsFactors = FALSE,
        na.strings = TRUE

      )

    #Append country name to data frame
    data$country <- country.list[i, 1]

    #Rearrange the columns
    data <- data[, c(8, 7, 1, 2, 3, 5)]


    #Column Names
    colnames(data) <-
      c(
        "country",
        "language_short_code",
        "date",
        "total_edits",
        "ip_edits",
        "minor_edits"
      )

    #Append 01 to yyyy/mm
    data$date <-
      paste0(substr(data$date, 1, 4),
             "-",
             substr(data$date, 8, 9),
             "-01")

    #Remove first row
    data <- data[-1, ]


    data$date <- as.Date(data$date, format = '%Y-%m-%d')

    #Write to database
    dbWriteTable(
      mydb,
      name = paste0("wikiedits_", continent),
      value = data,
      append = TRUE,
      row.names = FALSE
    )

    #Add new column matching language short codes to language
    data$Language <-
      languageCodes$V1[match(data$language_short_code, languageCodes$V3)]

    #Write to text file
    write.table(
      data,
      file = paste0(country.list[i, 1], "_Tidy.txt"),
      sep = ",",
      row.names = FALSE
    )

  }

  #Commit the changes and disconnect
  dbCommit(mydb)
  dbDisconnect(mydb)
}
