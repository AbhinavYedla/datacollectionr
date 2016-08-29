######################################################################################################
#                                      Wikipedia Page Views Scrape                                   #
######################################################################################################
#'
#' @description
#' Get Number of views of a wikipedia page using on the WikiViews functions.
#'
#' @param
#' None
#' @return
#' One file is created for each country
#'
#' @details
#' Its not a function. This is data collection code based on the WikiViews function. Parallel programming
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
#' Parallel programming, Wikipedia Page Views
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
foreach(i= 1:total.countries) %dopar% {

  #Parallel processing create mutiple images/objects. Each of which need librarys to be loaded
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
    list("Project", "TimeStamp", "Views"),
    file = paste(country.list[i, 1], ".txt", spe = ""),
    append = TRUE,
    sep = "  ",
    row.names = FALSE,
    col.names = FALSE
  )


  # Iterate over all the pages avaliable for each country
  for (j in 1:total.pages)  {

    # To catch any processing error
    tryCatch( {

      #Get data from WikiViews fucntion
      interm.data <- GetPageViewsNew(langList[j, 1], langList[j, 2])

      write.table(
        interm.data,
        file = paste(country,.list[i, 1], ".txt", spe = ""),
        append = TRUE,
        sep = "  ",
        row.names = FALSE,
        col.names = FALSE
      )

      # Sleep for 1 second so that there will not be mutiple request made at once
      Sys.sleep(1)

    }, error = function(e) {

      #Sleep for 30 seconds and store detials about the errored country
      Sys.sleep(30)
      j <- j - 1
      errorList <- c(errorList, c(langList[j, 1], langList[j, 2]))
    })
  }
}


#Stop the cluster
stopCluster(cl)
