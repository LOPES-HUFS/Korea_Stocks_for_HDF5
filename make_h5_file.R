library("hdf5")
library(xts)
library(plotly)
stock_005930 <- read.csv(file = "./stocks/005930.csv", header = TRUE, stringsAsFactors=FALSE)
stock_066570 <- read.csv(file = "./stocks/066570.csv", header = TRUE, stringsAsFactors=FALSE)

savename <- "temp.h5" #Name of file to create
file.h5 <- H5File$new(savename, mode="w")

path_list <- paste("./stocks/",dir("./stocks"),sep="")

create_h5_file<-function(stocknumber){
    file_path <- paste("https://raw.githubusercontent.com/LOPES-HUFS/Korea_Stocks_for_HDF5/master/stocks/",stocknumber,".csv",sep="")
    stock_temp <- read.csv(file = file_path, header = TRUE, stringsAsFactors=FALSE)
    data_name <- paste("_",stocknumber,sep = "")
    stock.grp <- file.h5$create_group(data_name)
    stock.grp[['data']] <- as.matrix(stock_temp[,2:7])
    stock.grp[['index']] <- as.matrix(stock_temp[,1])
    h5attr(stock.grp[["data"]], "colnames") <- colnames(stock_temp)[2:7]
    h5attr(stock.grp[["index"]], "colnames") <- "Date"
}

lapply(path_list,function(x){create_h5_file(x)})
file.h5$close_all()

# 열어서 확인 
file.h5 <- H5File$new("temp.h5", mode="r+")
temp_stock <- file.h5[[paste(names(file.h5)[1],"/data",sep = "")]]
temp_data <- temp_stock[,]
colnames(temp_data) <- h5attr(temp_stock,"colnames")
temp_index <- file.h5[[paste(names(file.h5)[1],"/index",sep = "")]]
new_stock <- as.xts(temp_data, order.by = as.Date(temp_index[,]))
head(new_stock)


stock_samsung <- data.frame(Date=as.Date(samsung_index[,]),samsung_data)
plot_ly(stock_samsung,x=~Date,type="candlestick",
                 open = ~Open, close = ~Adj.Close,
                 high = ~High, low = ~Low)