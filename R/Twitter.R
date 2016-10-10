#' Create twitter account
#' https://apps.twitter.com and sign on with your twitter account.
#' Create New App
#' Add dummy url if you dont have a website 
#' 


install.packages("twitteR")

library(twitteR)

consumerKey <- "x3Ys4mDBNWnRwaEUOF6tALWxY"
consumerSecret <- "8xKE0jxpv5FQFuCAJVmNqiBlE6fRoE6Zhi1w27AFDMBKcfUMQ9"
access_token <- 	"185158936-9EiUC0uQ9zkIYKKExdUEwRI0ZdCik49QuecjHK8f"
access_secret <- "hC33UUzqHjvDXODVlFy33kOgPNyV6ajVAYJvUB7Uoad1N"

setup_twitter_oauth(consumerKey, consumerSecret, access_token, access_secret)

a<-searchTwitter(searchString = 'TrevonMartin',n = 1000)

aa<-twListToDF(a)


trendLoc <- availableTrendLocations()

closestTrendLocations()
data <- getTrends(2459115)

toDataFrame
data2 <- searchTwitter("Olympics", n=25, lang=NULL, since="2012-08-01",
              locale=NULL, geocode=NULL, sinceID=NULL, maxID=NULL,
              resultType=NULL, retryOnRateLimit=120)
Rtweets(n=25, lang=NULL, since=NULL)

## Not run: 
register_sqlite_backend("/path/to/sqlite/file")
tweets <- searchTwitter("#TrevonMartin")
store_tweets_db(tweets)
from_db = load_tweets_db()

data2[[1]]
tweets

write.table(unlist(tweets))