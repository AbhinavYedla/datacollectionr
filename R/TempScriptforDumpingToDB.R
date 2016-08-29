
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
    dbname = 'soclab',
    host = '127.0.0.1'
  )
 

  continent ="europe"
  
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
        file = paste0("~/Wiki/Data/Wiki.Edits.TidyData/",country.list[i, 1], "_Tidy.txt"),
        header = TRUE,
        encoding = "UTF-8",
        stringsAsFactors = FALSE,sep=","
      )
    
    
    
    
    #Write to database
    dbWriteTable(
      mydb,
      name = paste0("wikiedits_",continent),
      value = data[,1:6],
      append = TRUE,
      row.names = FALSE,
      overwrite=FALSE
    )
    
  
  }
  
  #Commit the changes and disconnect
  dbCommit(mydb)
  dbDisconnect(mydb)
  
  
  
  ### for top 1000
  data <-
    read.table(
      file = paste0("~/Wiki/Data/WikipediaTop1000_EN_2016.txt"),
      header = TRUE,
      encoding = "UTF-8",
      stringsAsFactors = FALSE,sep=","
    )
  
  
  
  
  #Write to database
  dbWriteTable(
    mydb,
    name = paste0("wikipedia_top1000"),
    value = data,
    append = TRUE,
    row.names = FALSE,
    overwrite=FALSE
  )
  

    # for language codes
  languageCodes<-languageCodes[,c(1,3)]
  colnames(languageCodes) <- c("language","language_short_code")
    dbWriteTable(
      mydb,
      name = paste0("language_mapping"),
      value = ,
      append = TRUE,
      row.names = FALSE,
      overwrite=FALSE
    )
    
    write.table(languageCodes,"a.txt",row.names = FALSE,col.names = FALSE,quote = FALSE,sep=",")
  
  