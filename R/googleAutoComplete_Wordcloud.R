#Get familiar with the wordcloud package and write code to generate one topline wordcloud containing all
#words in our tidy dataset and then write two loops that create country-specific wordclouds for each target
#country and origin country. Write this in markdown so that the generate graphs are stored in a file
#(HTML & PDF).



library(tm)
library(SnowballC)
library(wordcloud)

data <-
  read.delim("GoogleAutoComplete_Tidy_2_Countries.txt", sep = "\t")

jeopCorpus <- Corpus(VectorSource(data[, c(-1,-2,-3,-4)]))
jeopCorpus <- tm_map(jeopCorpus, PlainTextDocument)
jeopCorpus <- tm_map(jeopCorpus, removePunctuation)
jeopCorpus <-
  tm_map(jeopCorpus,
         removeWords,
         c('the', 'this', 'No Value', stopwords('english')))

wordcloud(jeopCorpus, max.words = 200, random.order = FALSE)



col.name <- colnames(data[, c(-1,-2,-3,-4,-5)])
col.name <- gsub("\\.", " ", col.name)

n <- 195
#Origin
for (i in 1:n) {
  start <- i + 5
  print(col.name[i])
  jeopCorpus <- Corpus(VectorSource(data[, start]))
  jeopCorpus <- tm_map(jeopCorpus, PlainTextDocument)
  jeopCorpus <- tm_map(jeopCorpus, removePunctuation)
  jeopCorpus <-
    tm_map(
      jeopCorpus,
      removeWords,
      c(
        'the',
        'this',
        'No Value',
        'low',
        'high',
        'water',
        'river',
        'many',
        'blue',
        'called',
        stopwords('english')
      )
    )
  wordcloud(jeopCorpus, max.words = 1950, random.order = FALSE)
  
}

noval.list <- c(8,
                11,
                27,
                36,
                41,
                43,
                59,
                71,
                94,
                96,
                116,
                117,
                129,
                130,
                140,
                149,
                150,
                153,
                175,
                177,
                187,
                19)

#Target
for (i in 1:n) {
  if(is.element(i,noval.list))
      next
  start <- (i - 1) * 10 + 1
  end <- (i - 1) * 10 + 10
  print(col.name[i])
  jeopCorpus <- Corpus(VectorSource(data[start:end, c(-1, -2, -3, -4, -5)]))
  jeopCorpus <- tm_map(jeopCorpus, PlainTextDocument)
  jeopCorpus <- tm_map(jeopCorpus, removePunctuation)
  jeopCorpus <-
    tm_map(
      jeopCorpus,
      removeWords,
      c(
        'the',
        'this',
        'new',
        'No Value',
        'low',
        'high',
        'water',
        'river',
        'many',
        'blue',
        'called',
        stopwords('english')
      )
    )
  
  tryCatch({
    wordcloud(jeopCorpus, random.order = FALSE,min.freq = 10,scale(4,0.2))
  }, error = function(ex) {
    #cat("Unable to reach API")
    
    
  }, finally = {
    #closeAllConnections()
    
  })
}


png("wordcloud_packages.png", width=1280,height=800)
wordcloud(corpus, ,min.freq=3,
          max.words=Inf, random.order=FALSE, )
dev.off()