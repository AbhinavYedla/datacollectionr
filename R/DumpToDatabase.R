install.packages("RMySQL")
library(readxl)
library(XLConnect)
install.packages("readxl") 
mydb = dbConnect(MySQL(), user='root', password='root', dbname='wikipedia', host='127.0.0.1')
dbListTables(mydb)
# treat / as "


  dbSendQuery(mydb, 'aLTER TABLE `id` MODIFY `page_title` varchar(100) CHARACTER SET utf8mb4')
  
  dbWriteTable(mydb, name='data2015', value=data2015,append=TRUE, row.names = FALSE)


d<- read.delim(file="aa.txt",sep="\t",encoding ="utf8mb4")

#a<- read.csv(file="aa.txt",sep="\t",encoding ="UTF-8")
colnames(d) <- c("id", "page_title")

dbDisconnect(mydb)

data2015<- read.delim(file="2015.txt",sep="\t",encoding ="utf8mb4")

#a<- read.csv(file="aa.txt",sep="\t",encoding ="UTF-8")
colnames(data2015) <- c("page_title", "rank","views","date")

dbWriteTable(mydb, name='wikitop1000', value=data2015,append=TRUE, row.names = FALSE)



data2016<- read.delim(file="2016.txt",sep="\t",encoding ="utf8mb4")

#a<- read.csv(file="aa.txt",sep="\t",encoding ="UTF-8")
colnames(data2016) <- c("page_title", "rank","views","date")

dbWriteTable(mydb, name='wikitop1000', value=data2016,append=TRUE, row.names = FALSE)



