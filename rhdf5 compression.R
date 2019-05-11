install.packages("BiocManager")
BiocManager::install("rhdf5")
library(rhdf5)
h5createFile("all_stock.h5")
h5createGroup(file = "all_stock.h5",group = "colnames")
h5write(c("Date","Open","High","Low","Close","Volume","Adj_Close"), "all_stock.h5","colnames")
create_h5_file<-function(filename){
    stock_temp <- read.csv(file = filename, header = TRUE, stringsAsFactors=FALSE)
    data_name <- paste("kr",substr(filename,10,15),sep = "")
    h5createGroup(file = "all_stock.h5",group = data_name)
    h5createDataset("all_stock.h5", paste(data_name,"/data",sep=""), c(NROW(stock_temp),6),storage.mode = "integer", chunk=c(NROW(stock_temp),6), level=9)
    h5write(as.matrix(stock_temp[,2:7]), file="all_stock.h5",name=paste(data_name,"/data",sep=""))
    h5createDataset("all_stock.h5", paste(data_name,"/index",sep=""), c(NROW(stock_temp),1),storage.mode = "character", size=11,chunk=c(NROW(stock_temp),1), level=9)
    h5write(as.matrix(stock_temp[,1]), file="all_stock.h5",name=paste(data_name,"/index",sep=""))
}

lapply(path_list,function(x){create_h5_file(x)})

h5closeAll()
    


