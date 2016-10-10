library(plyr)
filenames <-
  list.files(path = "GoogleNationalities",
             pattern = "*txt",
             full.names = TRUE)
n <- 280


for (i in 1:n) {
  file.data <- read.table(filenames[i], header = TRUE)
  
  write.table(
    file.data,
    file = "GoogleAutoComplete_Nationalities.txt",
    sep = "\t",
    append = TRUE,
    col.names = FALSE,
    row.names = FALSE
  )
  
}

worldList <- read.delim("data/Nationalities.txt",header = TRUE)


for(i in 1:283){
  
  word <- paste0("why are ", tolower(worldList[i,2]), " so ")
  write.table(
    word,
    file = "wordlist.txt",
    sep = "\t",
    append = TRUE,
    col.names = FALSE,
    row.names = FALSE
  )
}

file.data <- read.table("GoogleAutoComplete_Nationalities.txt", header = TRUE)

wordLookup <- read.table("wordlist.txt", header = FALSE)

x <- readLines("GoogleAutoComplete_Nationalities.txt")

for( i in 1 : 283 ){
  y <- gsub( wordLookup[i,1], "", x )
  x = y
  
  
}
cat(y, file="GoogleAutoComplete_Nationalities.txt", sep="\n")