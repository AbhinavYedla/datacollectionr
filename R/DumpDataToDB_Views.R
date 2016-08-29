
mydb = dbConnect(MySQL(), user='root', password='root', dbname='wikipedia', host='127.0.0.1')


countryList <- read.table("~/wikipagestats/CountryList.txt",col.names="Country")

for(i in 1: 45){
  
  z<-read.table(file=as.character(paste0(countryList[i,1],".txt")),header=TRUE)
  
  z$Project <- substr(z$Project,1,regexpr("[.]",as.character(z$Project))-1)
  
  z$TimeStamp <- paste0(substr(z$TimeStamp,1,4),"-",substr(z$TimeStamp,5,6),"-",substr(z$TimeStamp,7,8))
  
  z$CountryName <- countryList[i,1]
  z <- z[,c(4,1,2,3)]
 colnames(z)<-c("country","language","date","views")
  
  dbWriteTable(mydb, name='wikiviews_a_c', value=z,append=TRUE, row.names = FALSE)
  
  
}

for(i in 46: 91){
  
  z<-read.table(file=as.character(paste0(countryList[i,1]," .txt")),header=TRUE)
  
  z$Project <- substr(z$Project,1,regexpr("[.]",as.character(z$Project))-1)
  
  z$TimeStamp <- paste0(substr(z$TimeStamp,1,4),"-",substr(z$TimeStamp,5,6),"-",substr(z$TimeStamp,7,8))
  
  z$CountryName <- countryList[i,1]
  z <- z[,c(4,1,2,3)]
  colnames(z)<-c("country","language","date","views")
  
  dbWriteTable(mydb, name='wikiviews_d_k', value=z,append=TRUE, row.names = FALSE)
  
  
}

for(i in 92: 142){
  
  z<-read.table(file=as.character(paste0(countryList[i,1]," .txt")),header=TRUE)
  
  z$Project <- substr(z$Project,1,regexpr("[.]",as.character(z$Project))-1)
  
  z$TimeStamp <- paste0(substr(z$TimeStamp,1,4),"-",substr(z$TimeStamp,5,6),"-",substr(z$TimeStamp,7,8))
  
  z$CountryName <- countryList[i,1]
  z <- z[,c(4,1,2,3)]
  colnames(z)<-c("country","language","date","views")
  
  dbWriteTable(mydb, name='wikiviews_l_r', value=z,append=TRUE, row.names = FALSE)
  
  
}

for(i in 143: 194){
  
  z<-read.table(file=as.character(paste0(countryList[i,1]," .txt")),header=TRUE)
  
  z$Project <- substr(z$Project,1,regexpr("[.]",as.character(z$Project))-1)
  
  z$TimeStamp <- paste0(substr(z$TimeStamp,1,4),"-",substr(z$TimeStamp,5,6),"-",substr(z$TimeStamp,7,8))
  
  z$CountryName <- countryList[i,1]
  z <- z[,c(4,1,2,3)]
  colnames(z)<-c("country","language","date","views")
  
  dbWriteTable(mydb, name='wikiviews_s_z', value=z,append=TRUE, row.names = FALSE)
  
  
}