install.packages("BiocManager")
BiocManager::install("rhdf5")
library(rhdf5)
path_list <- paste("./stocks/",dir("./stocks"),sep = "")
h5createFile("all_stock.h5")
h5write(c("Date","Open","High","Low","Close","Volume","Adj_Close"), "test_all_stock.h5","colnames")
create_h5_file<-function(filename){
    stock_temp <- read.csv(file = filename, header = TRUE, stringsAsFactors=FALSE)
    data_name <- paste("_",substr(filename,10,15),sep = "")
    stock_temp$Date <- as.integer(paste(substr(stock_temp$Date,1,4),substr(stock_temp$Date,6,7),substr(stock_temp$Date,9,10),sep = ""))
    h5createGroup(file = "all_stock.h5",group = data_name)
    h5createDataset(file = "all_stock.h5", dataset = paste(data_name,"/data",sep=""), dims = c(NROW(stock_temp),7),storage.mode = "integer")
    h5write(as.matrix(stock_temp), file="all_stock.h5",name=paste(data_name,"/data",sep=""))
    }

lapply(path_list,function(x){create_h5_file(x)})

h5closeAll()
    
install.packages("dygraphs")
library(dygraphs)
library(tidyverse)
#temp에 rownames 로 날짜 넣어줌 
sample <- H5Fopen("all_stock.h5")

samsung_sample <- sample$"_005930"
samsung_sample$data
samsung_sample$index
sample$colnames

samsung_temp <- data.frame(samsung_sample$index,samsung_sample$data)
colnames(samsung_temp) <- sample$colnames

newTemp <- select(samsung_temp, "Open", "High", "Low", "Close")
rownames(newTemp) <- samsung_temp$Date
newTemp <- as.xts(newTemp)
dygraph(newTemp['2019'],main = "candlestick",group = "stock_graph") %>% dyRangeSelector() %>% dyCandlestick() 

temp <- select(samsung_temp, "Volume")
rownames(temp) <- samsung_temp$Date
temp <- as.xts(temp)
dygraph(temp['2019'],main = "volume",group = "stock_graph") %>% dyBarChart()

