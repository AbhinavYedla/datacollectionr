install.packages("streamR")
install.packages("RCurl")
install.packages("ROAuth")
install.packages("RJSONIO")
library(streamR)
library(RCurl)
library(RJSONIO)
library(stringr)
library(ROAuth)



requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "x3Ys4mDBNWnRwaEUOF6tALWxY"
consumerSecret <- "8xKE0jxpv5FQFuCAJVmNqiBlE6fRoE6Zhi1w27AFDMBKcfUMQ9"

my_oauth <- OAuthFactory$new(consumerKey=consumerKey,
                             consumerSecret=consumerSecret, requestURL=requestURL,
                             accessURL=accessURL, authURL=authURL)

my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))


### STOP HERE!!! ###

# PART 2: Save the my_oauth data to an .Rdata file
save(my_oauth, file = "my_oauth.Rdata")



load("my_oauth.Rdata")


filterStream( file="tweets_blm.json",
              track="BlackLivesMatter", timeout=600, oauth=my_oauth )

tweets.df <- parseTweets("tweets_blm.json", simplify = FALSE) # parse the json file and save to a data frame called tweets.df. Simplify = FALSE ensures that we include lat/lon information in that data frame.



filterStream(file.name = "tweets.json", # Save tweets in a json file
             track = "Things in the world have meanings that", # Collect tweets mentioning either Affordable Care Act, ACA, or Obamacare
             language = "en",
             timeout = 60, # Keep connection alive for 60 seconds
             oauth = my_oauth) # Use my_oauth file as the OAuth credentials

tweets.df2 <- parseTweets("tweets.json", simplify = FALSE) # parse the json file and save to a data frame called tweets.df. Simplify = FALSE ensures that we include lat/lon information in that data frame.


## capture tweets published by Twitter's official account
filterStream( file.name="tweets_twitter.json",
              follow="783214", timeout=600, oauth=my_oauth )


sampleStream("tweetsSample.json", timeout = 120, oauth = my_oauth, verbose = FALSE)
tweets.df <- parseTweets("tweetsSample.json", verbose = FALSE)
mean(as.numeric(tweets.df$friends_count)
     
     
colnames(tweets.df)

