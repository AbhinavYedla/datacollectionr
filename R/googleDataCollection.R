library(gautocompleter)
total.regions <- nrow(gSubDomain)
fill.data.frame <- as.data.frame(replicate(10, "No Value"))
colnames(fill.data.frame) <- "Result"
data <- fill.data.frame
df <- fill.data.frame

for (i in 1:total.regions) {
  query <- as.character("Why is ")
  target.region <- gSubDomain[i, 1]
  
  query <- paste0(query, target.region, " so ")
  
  for (j in 1:total.regions) {
    if(j!=127)
    data <-
      google_autocomplete(query = query, country = gSubDomain[j, 2])
    
    total.rows <- nrow(data)
    
    if (nrow(data) < 10)
      data <- rbind(data, fill.data.frame)
    
    df <- cbind(df, data[1:10,])
    
    Sys.sleep(0.5)
    
  }
  
  df <- df[,-1]
  colnames(df) <- gSubDomain[, 1]
  df$Target <- target.region
  
  df <- df[, c(total.regions + 1, 1:total.regions)]
  
  write.table(
    df,
    file = paste0(target.region, ".txt"),
    sep = "\t",
    row.names = FALSE,
    col.names = TRUE
  )
  
  df <- fill.data.frame
  
  
}
