


url <-
  "https://www.passportindex.org/comparebyPassport.php"

doc <- read_html(url)


xpath <-
  "//select[@name = 'col1']//option//text()"


dataXMLNodeSet <- html_nodes(doc, xpath = xpath)
data1 <- html_text(dataXMLNodeSet)

xpath <-
  "//select[@name = 'col1']//option//@value"


dataXMLNodeSet <- html_nodes(doc, xpath = xpath)
data2 <- html_text(dataXMLNodeSet)

df <- cbind(data1[2:200], data2[2:200])

matrixData <- matrix(NA, 199, 199)
colnames(matrixData) <- toupper(data2[2:200])
rownames(matrixData) <- toupper(data2[2:200])


fileName <- "data.txt"
conn <- file(fileName, open = "r")
lines <- readLines(conn)
len <- length(lines) / 4
for (n in 1:199) {
  i <- (n-1) * 4 + 1
  
  
  rowname <- substr(lines[i], 1, 2)
  
  for (j in 1:3) {
    colnames <-
      data.frame(strsplit(
        substr(lines[i], 6, nchar(lines[i])),
        split = ",",
        fixed = TRUE
      ))
    
    if (nrow(colnames) != 0) {
      for (k in 1:nrow(colnames)) {
        matrixData[as.character(rowname), as.character(colnames[k,])] <- j
      }
    }
    i <- i + 1
  }
}
close(conn)

m2 <- matrixData


colnames(m2) <- toupper(data[2:200])
rownames(m2) <- toupper(data[2:200])

write.table(m2,file="Country-specific passport data.csv",sep=",")

write.table(matrixData,file="Country-specific passport data With Short Code.csv",sep=",")

write.table(df,file="Short Code Mapping.csv",sep=",")

write.table(m3,file="Country-specific passport data With Short Code and Type Match.csv",sep=",")
m3 <- m2
m3[m3 == 1] <- "Visa Free"
m3[m3 == 2] <- "Visa On Arrival"
m3[m3 == 3] <- "ETA"
m3[is.na(m3)] <- ""

a<-data.frame(m3["AFGHANISTAN",])