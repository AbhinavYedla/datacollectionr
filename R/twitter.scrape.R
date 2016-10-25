##############################################################################
#                           Twitter Data Collection                          #
##############################################################################
#' @title
#' Twitter Country Data collection
#'
#' @description
#' This R file is used to get data related to the countries
#' Stores the data in seperate files.
#'
#' @author
#' Abhinav Yedla \email{abhinavyedla@gmail.com}
#'
#' @references
#'
#' @keywords
#' Twitter country data
#'
#' @seealso
#' \code{\link{gSubDomain}}
#'
#' @note
#' Too many requests can get you blocked so there is delay of 5 min when ever the limit is reached.
#'
#' @import twitteR
#'
#' @export

require(twitteR)

#REmove retweets and see if you can get the count of total retweets
#Authorize
connection()

#Get country list from gautocompleter package
countries <- gautocompleter::gSubDomain

#Maximum number of tweets per request
max.tweets <- 8000

#Total Countries count
total.countries <- nrow(countries)

#Countries with no tweets
zero.tweets <- data.frame("", stringsAsFactors = FALSE)
colnames(zero.tweets) <- "Country"

#Counter for subset of data
count <- 1

#Loop through all the countries
for (i in 11:total.countries) {
  #Build the search string
  search.string <- as.character(countries[i, 1])
  
  #Search twitter for the above search string
  result <-
    searchTwitter(searchString = search.string,
                  n = max.tweets,
                  since = "2016-10-14")
  
  #If there are no tweets then skip to next country
  if (length(result) == 0) {
    zero.tweets <- rbind(zero.tweets, as.character(countries[i, 1]))
    next
  }
  
  #Convert the list to data frame
  result.df <- twListToDF(result)
  
  #Get the total tweets retrieved
  total.rows <- nrow(result.df)
  
  #Write to text file
  write.table(
    result.df,
    file = paste0("Twitter_Country/", countries[i, 1], "_Twitter.txt"),
    row.names = FALSE,
    sep = "\t"
  )
  
  #If exceeds the limit then try to rerun with max id being the oldest tweets id from the current result set
  while (total.rows == max.tweets) {
    
    if(count > 5)
      break;
    Sys.sleep(22)
    result <-
      searchTwitter(searchString = search.string,
                    n = max.tweets,
                    maxID = result.df[total.rows, 8])
    
    #Convert the list to data frame
    result.df <- twListToDF(result)
    
    #Get the total tweets retrieved
    total.rows <- nrow(result.df)
    
    count <- count + 1
    
    #Write to text file
    write.table(
      result.df,
      file = paste0("Twitter_Country/", countries[i, 1], "_Twitter.txt"),
      row.names = FALSE,
      append = TRUE,
      col.names = FALSE,
      sep = "\t"
    )
    
    limit <- getCurRateLimitInfo(resources = resource_families)
    
    #If nearing limit then wait for 5 minutes
    if (limit[62, 3] < 41) {
      Sys.sleep(500)
    }
  }
  
  
  #Get the number of avaliable request remaining
  limit <- getCurRateLimitInfo(resources = resource_families)
  
  #If nearing limit then wait for 5 minutes
  if (limit[62, 3] < 41) {
    Sys.sleep(300)
  }
  
  count <- 1
}

#Note the countries without any tweets
write.table(
  zero.tweets[-1,],
  file = paste0("Twitter_Country/NoTweets_Twitter.txt"),
  row.names = FALSE,
  append = TRUE
)