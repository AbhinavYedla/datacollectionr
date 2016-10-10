library(plyr)
library(gautocompleter)
filenames <-
  list.files(path = "GoogleAutoCompleteData",
             pattern = "*txt",
             full.names = TRUE)
n <- 195


for (i in 1:n) {
  file.data <- read.table(filenames[i], header = TRUE)
  
  write.table(
    file.data,
    file = "GoogleAutoComplete_Countries.txt",
    sep = "\t",
    append = TRUE,
    col.names = FALSE,
    row.names = FALSE
  )
  
}

worldList <- data.frame(gSubDomain[,1])

for(i in 2:196){
  
  word <- paste0("why is ", tolower(worldList[i,1]), " ")
  write.table(
    word,
    file = "wordlist.txt",
    sep = "\t",
    append = TRUE,
    col.names = FALSE,
    row.names = FALSE
  )
}

file.data <- read.table("GoogleAutoComplete_Tidy_Countries.txt", header = TRUE)

wordLookup <- read.table("wordlist.txt", header = FALSE)

x <- readLines("GoogleAutoComplete_Tidy_Countries.txt")

for( i in 1 : 195 ){
  y <- gsub( wordLookup[i,1], "", x )
  x = y
  
  
}
cat(y, file="GoogleAutoComplete_Tidy_2_Countries.txt", sep="\n")