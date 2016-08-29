#############################################################################
#               Tidy Wikipedia Views Data and dump it to database           #
#############################################################################
#'
#' @description
#' Tidy the data retrieved from WikiViews function and store it in a
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
#' WikiViewsTidy("North_America")
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

WikiViewsTidy <- function(continent){

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
      read.table(
        file = paste0("~/wikipagestats/WikiViews/",countryListDf[i, 1], ".txt"),
        header = TRUE,
        encoding = "UTF-8",
        stringsAsFactors = FALSE,
        col.names = c("language_short_code", "date", "views")
      )

    #Remove .wikipedia text from language short code
    data$language_short_code <-
      gsub(".wikipedia", "", data$language_short_code, fixed = TRUE)

    #Format date
    data$date <-
      paste0(substr(data$date, 1, 4),
             "/",
             substr(data$date, 5, 6),
             "/",
             substr(data$date, 7, 8))

    #Append country name to data frame
    data$country <- country.list[i, 1]

    #Rearrange the columns
    data <- data[, c(4, 1, 2, 3)]

    #Add new column matching language short codes to language
    data$Language <- languageCodes$V1[match(data$language_short_code,languageCodes$V3)]

    #Write to database
    dbWriteTable(
      mydb,
      name = paste0("wikiviews_",continent),
      value = data[,c(1:4)],
      append = TRUE,
      row.names = FALSE,
      overwrite=FALSE
    )
    #Write to text file
    write.table(data,file=paste0(countryListDf[i,1],"_Tidy.txt"),sep=",",row.names = FALSE)

  }

  #Commit the changes and disconnect
  dbCommit(mydb)
  dbDisconnect(mydb)
}
