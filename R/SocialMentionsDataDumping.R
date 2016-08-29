#############################################################################
#                 Dump social mentions data to relational database          #
#############################################################################


SocialMentionsDataDumping <- function(file.name ) {
  
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
  
  file.name = "SocialMentions_06272016.txt"
  
    data <-
    read.table(file = file.name,
               header = TRUE,
               sep = "\t")
    data$timeframe <- "w"

 #data$Date <- "2016-06-19"
  colnames(data) <- c("Date",
                  "Source",
                  "Term",
                  "Strength",
                  "Sentiment",
                  "Passion",
                  "Reach",
                  "TimeFrame")
  
  
  
  #Establishing connection with database
  mydb = dbConnect(
    MySQL(),
    user = 'root',
    password = 'root',
    dbname = 'soclab',
    host = '127.0.0.1'
  )
  
  
  #Write to database
  dbWriteTable(
    mydb,
    name = "social_mentions",
    value = data,
    append = TRUE,
    row.names = FALSE
  )
  
  
  #Commit the changes and disconnect
  dbCommit(mydb)
  dbDisconnect(mydb)
}
