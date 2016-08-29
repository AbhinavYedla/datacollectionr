#####################################################################################################################
#                                                       Social Mentions                                             #
#####################################################################################################################
#'
#' @description
#' Get Strength, Sentiment, Passion and Reach of a term or list of terms in Blogs, MicroBlogs, Bookmarks, Images or all of the sources
#' using the SocialMention function.
#'
#' @param source.path - Path to the file which contains the terms
#'
#' @return
#' A data frame consisting of consolidated data related to the term belonging to a source with in the given time frame is
#' returned.
#'
#' @examples
#' socialMentionDataCollection(source.path = "~/SocialMentions/Data/SourceList.txt")
#'
#'
#' @references
#'
#' @seealso
#' \code{\link{}}
#'
#' @keywords
#' Social Mentions Data
#'
#' @export
#'
#' @author
#' Abhinav Yedla \email{abhinavyedla@gmail.com}
#'

socialMentionDataCollection <-
  function(source.path = "~/SocialMentions/Data/SourceList.txt",data.path = "~/SocialMentions/a.txt") {
    df.datacoll <- data.frame()
    
    #List of sources
    source.datacoll <- c("blogs",
                         "microblogs",
                         "bookmarks",
                         "images",
                         "all")
    
    #Time frame of the required results
    time.frame.datacoll <- "w"
    
    #Read source terms from file
    countryList <- read.delim2(source.path, header = FALSE)
    
    n.datacoll <- length(countryList$V1)
    
    c <- data.frame("Date",
      "Source",
      "Term",
      "Strength",
      "Sentiment",
      "Passion",
      "Reach",
      "TimeFrame")
    
    write.table(
      x = c,
      file = data.path,
      sep = "\t",
      row.names = FALSE,
      col.names = FALSE
    )
    
    
    
    
    #Iterate over each term and write the results to file
    for (i in 1:n.datacoll) {
      write.table(
        socialMention(countryList[i, ], source.datacoll, time.frame.datacoll),
        file = data.path,
        sep = "\t",
        row.names = FALSE,
        col.names = FALSE,
        append = TRUE
      )
      
    }
    
    
  }
