######################################################################################################
#                                      Wikipedia Page Edits Scrape                                   #
######################################################################################################
#'
#' @description
#' Get Number of edits of a wikipedia page using on the WikiEdits function.
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

if (!require("doParallel")) {
  print("Trying to install doParallel")
  install.packages("doParallel")
  if (require(doParallel)) {
    print("doParallel installed and loaded")
  } else {
    stop("Could not install doParallel")
  }
}

if (!require("foreach")) {
  print("Trying to install foreach")
  install.packages("foreach")
  if (require(foreach)) {
    print("foreach installed and loaded")
  } else {
    stop("Could not install foreach")
  }
}

if (!require("rvest")) {
  print("Trying to install rvest")
  install.packages("rvest")
  if (require(rvest)) {
    print("rvest installed and loaded")
  } else {
    stop("Could not install rvest")
  }
}

if (!require("jsonlite")) {
  print("Trying to install jsonlite")
  install.packages("jsonlite")
  if (require(jsonlite)) {
    print("jsonlite installed and loaded")
  } else {
    stop("Could not install jsonlite")
  }
}

if (!require("wikipediatrend")) {
  print("Trying to install wikipediatrend")
  install.packages("wikipediatrend")
  if (require(wikipediatrend)) {
    print("wikipediatrend installed and loaded")
  } else {
    stop("Could not install wikipediatrend")
  }
}

# Find out how many cores are available (if you don't already know)
detectCores()

# Create cluster with desired number of cores
cl <- makeCluster(detectCores() - 1)

# Register cluster
registerDoParallel(cl)

# Find out how many cores are being used
getDoParWorkers()

#Error list to capture any processing errors
error.list <- list()

#Read country Names from text file
country.list <- read.table("~/Wiki/Data/CountryList.txt", col.names = "Country")


total.countries <- length(country.list$Country)

# '%dopar%' is the keyword to start parallel processing
foreach (i = 1 : total.countries) %dopar% {

  #Parallel processing create mutiple images/objects. Each of which need librarys to be loaded
  library(rvest)
  library(jsonlite)
  library(wikipediatrend)
  library(doParallel)
  library(foreach)

  #Get all wikipedia language pages associated with given country
  lang.list <- wp_linked_pages(country.list[i, 1],"en")

  #Appending English to lang.list
  lang.list <- rbind(lang.list,list(country.list[i, 1],"en",country.list[i, 1]))


  total.pages <-  length(lang.list[, 2])

  write.table(
    list("Date","Number of edits","IPs","IPs Percentage","Minor edits","Minor edits Percentage"),
    file = paste0(country.list[i, 1], ".csv"),
    append = TRUE,
    sep=",",
    row.names = FALSE,
    col.names = FALSE
  )

  # Iterate over all the pages avaliable for each country
  for (j in 1:total.pages)  {

    # To catch any processing error
    tryCatch( {

      #Get data from WikiEdits fucntion
      interm.data <- WikiEdits(lang.list[j, 1], lang.list[j, 2])

      write.table(
        interm.data,
        file = paste0(country.list[i, 1], ".csv"),
        append = TRUE,
        sep=",",

        row.names = FALSE,
        col.names = FALSE
      )

      # Sleep for 1 second so that there will not be mutiple request made at once
      Sys.sleep(1)

    }, error = function(e) {

      #Sleep for 30 seconds and store detials about the errored country
      Sys.sleep(30)
      j <- j - 1
      error.list <- c(error.list, c(lang.list[j, 1], lang.list[j, 2]))
    })
  }



}

#Stop the cluster
stopCluster(cl)
