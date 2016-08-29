#############################################################################
#                               Google Trends                               #
#############################################################################
#'
#' @description
#' Collecting Google trends data using gtrendsR package
#'
#' @param
#'
#' @return
#'
#' @details
#' Fetch google trends data for all the countires. Each country data is stored
#' in seperate file and in one single database table.
#'
#' @note
#' Region specific data is avaliable. Numbers represent search interest 
#' relative to the highest point on the chart. If, at most, 10% of searches
#' for the given region and time frame were for "pizza", we'd consider this
#' 100. This doesn't convey absolute search volume.
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
#' Google trends
#'
#' @seealso
#' \code{\link{}}
#'
#' @export


if (!require("gtrendsR")) {
  print("Trying to install gtrendsR")
  install.packages("gtrendsR")
  if (require(gtrendsR)) {
    print("gtrendsR installed and loaded")
  } else {
    stop("Could not install gtrendsR")
  }
}

user <- "abhinavyedla@gmail.com"
psw <- ""

if (is.null(gconnect(user, psw))) {
  stop("Login Failed")
}

country.list <-
  data.frame(unique(countries[, c("code", "country")]))

total.countries <- nrow(country.list)

for (i in 1:total.countries) {
  df <- data.frame(matrix(0, nrow = 652, ncol = total.countries + 2))
  
  for (j in 1:total.countries) {
    res <-
      gtrends(
        query = country.list$country[unique(c(seq(1, from = j, to = j + 3) , i))],
        geo = country.list$code[i],
        start_date = "2004-01-01",
        end_date = Sys.Date() - 1
      )
    
    
    Sys.sleep(2)
    
    #check if data is going to respective columns or not
    
    df[, seq(1, from = j + 2, to = j + 5)] <- res$trend[, 3:6]
    
    
    #Below is not required as of now.
    write.table(
      res[as.character(paste0("Top.subregions.for.", tolower(country.list$country[i])))],
      paste0("Top.subregions.", country.list$country[i], ".txt"),
      sep = ",",
      append = TRUE,
      row.names = FALSE,
      col.names = FALSE
    )
    write.table(
      res[as.character(paste0("Top.cities.for.", tolower(country.list$country[i])))],
      paste0("Top.cities.", country.list$country[i], ".txt"),
      sep = ",",
      append = TRUE,
      row.names = FALSE,
      col.names = FALSE
    )
    write.table(
      res[as.character(paste0("Top.searches.for.", tolower(country.list$country[i])))],
      paste0("Top.searches.", country.list$country[i], ".txt"),
      sep = ",",
      append = TRUE,
      row.names = FALSE,
      col.names = FALSE
    )
    write.table(
      res[as.character(paste0("Rising.searches.for.", tolower(country.list$country[i])))],
      paste0("Rising.searches.", country.list$country[i], ".txt"),
      sep = ",",
      append = TRUE,
      row.names = FALSE,
      col.names = FALSE
    )
    
    j <- j + 4
    
    
  }
  
  df[, c(1, 2)] <- res$trend[, c(1, 2)]
  
  write.table(
    df,
    paste0(country.list$country[i], ".txt"),
    sep = ",",
    append = TRUE,
    row.names = TRUE,
    col.names = FALSE
  )
  
}