#############################################################################
#              Wikipedia Top 1000 Pages Tidying (Only English)              #
#############################################################################
#'
#' @description
#' Get Top 1000 wikipedia pages based on the given date
#'
#' @param
#' None
#'
#' @return
#' Write to the database and the text file
#'
#' @details
#'
#'
#' \code{}
#'
#' @examples
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
#'

WikiTop1000Tidy <- function() {

  #Initilise the date based on the data collection date
  data.year <- "20160526"

  #Get all the countries
  country.list <-
    read.delim("country.list.txt", sep = "\t", header = FALSE)

  total.countries <- nrow(country.list)


  data.country.lang <-
    read.delim("Country_Lang.txt", sep = "\t", header = FALSE)

  #  for (i in 1:total.countries) {
  #   write.table(
  #    wikiPageAllLanguages(country.list[i, ])[, 2:3],
  #   file = "Country_Lang.txt",
  #  sep = "\t",
  # append = TRUE,
  #row.names = FALSE,
  #    col.names = FALSE
  # )
  #}

  #Get all the linked languages of a given page
  wiki.all.lang <- wp_linked_pages("wikipedia","en")[, 2:3]


  total.lang <-
    read.delim("LanguageCodes.txt", sep = "\t", header = FALSE)[, 3]


  count.total.lang <- nrow(total.lang)

  #Iterate through all the languages
  for (i in  1:count.total.lang) {


    file.name <- paste0(total.lang[i], "_", data.year, ".txt")

    if (file.exists(file.name)) {
      data <-
        read.delim(file = file.name,
                   sep = " ",
                   header = FALSE)[,2:5]

      #Add master code column to data frame
      data.tidy$masterCode <- 0

      #Assign master code as 1 for all wikipedia related pages
      data.tidy$masterCode[grep(
        "Wikipedia|Main_Page",
        ignore.case = TRUE,
        perl = TRUE,
        x = data.tidy$V2
      )] <- 1


      #Assign master code as 1 for all wikipedia realted pages in different languages
      data.tidy$masterCode[grep(
        wiki.all.lang[wiki.all.lang$lang == total.lang[i],][1,2],
        ignore.case = TRUE,
        perl = TRUE,
        x = data.tidy$V2
      )] <- 1


      #Assign master code as 2 for all user realted pages
      data.tidy$masterCode[grep(
        "user:",
        ignore.case = TRUE,
        perl = TRUE,
        x = data.tidy$V2
      )] <- 2


      country.list_language <-
        data.country.lang[data.country.lang$V1 == as.character(total.lang[i]),]

      #Read all data from text file and append Burma to that list
      country.list <-
        read.table("country.list.txt",
                   header = FALSE,
                   stringsAsFactors = FALSE)
      country.list[195, ] <- "Burma"


      #data.tidy$masterCode[grep(paste(country.list,collapse = "|"),fixed = TRUE,x = data.tidy$V2)] <- 3


      count.lang.specific <- nrow(country.list_language)

      count <- nrow(country.list)
      if(count.lang.specific != 0){
      for (i in 1:count.lang.specific) {
        #Assign Master of 3 to all pages realted to country. Checking in all different languages
        data.tidy$masterCode[data.tidy$V2 == country.list_language[i, 1]] <-  3
      }
      }

      for (i in 1:count) {
        data.tidy$masterCode[data.tidy$V2 == country.list[i, 1]] <-
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

      #Assign Master of 4 to all pages realted to dates
      data.tidy$masterCode[grep(paste(months, collapse = "|"),
                                fixed = FALSE,
                                x = data.tidy$V2)] <- 4

      # \\d{4} is Regualr expression for 4 digits
      data.tidy$masterCode[grep("\\d{4}", fixed = FALSE, x = data.tidy$V2)] <-
        4

      colnames(data.tidy) <-c(
        "Page_Title", "Views", "Rank", "Date", "Master_Code"
      )

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
        dbname = 'soclab',
        host = '127.0.0.1'
      )
      
      dbWriteTable(
        mydb,
        name = "wikipedia_top1000",
        value = data.tidy,
        append = TRUE,
        row.names = FALSE,
        overwrite=FALSE
      )
      
      write.table(
        x = data.tidy[order(-data.tidy$Master_Code),],
        file = paste0(total.lang[i], "_", data.year, "_Tidy.txt"),

        row.names = FALSE

      )


    } else{
      nofileFoundList <- rbind(nofileFoundList, file.name)
    }

  }
}
