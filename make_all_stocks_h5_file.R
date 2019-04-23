library(hdf5)
library(xts)

savename <- "all_stocks.h5" #Name of file to create
file.h5 <- H5File$new(savename, mode="w")
path_list <- paste("./stocks","/",dir("./stocks"),sep="")

# compound 형식일 때
stock.grp <- file.h5$create_group("stocks")

create_h5_file<-function(filename){
    stock_temp <- read.csv(file = filename, header = TRUE, stringsAsFactors=FALSE)
    data_name <- paste("_",substr(filename,10,15),sep = "")
    stock.grp[[data_name]] <- stock_temp
}
#요런식으로 확인 가능 
file.h5[['stocks/_000020']][1:file.h5[['stocks/_000020']]$dims]


create_h5_file<-function(filename){
    stock_temp <- read.csv(file = filename, header = TRUE, stringsAsFactors=FALSE)
    data_name <- paste("_",substr(filename,10,15),sep = "")
    stock.grp <- file.h5$create_group(data_name)
    stock.grp[['data']] <- as.matrix(stock_temp[,c(2,3,4,5,6,7)])
    stock.grp[['index']] <- as.matrix(stock_temp[,1])
    h5attr(stock.grp[["data"]], "colnames") <- colnames(stock_temp)[2:7]
    h5attr(stock.grp[["index"]], "colnames") <- "Date"
}

lapply(path_list,function(x){create_h5_file(x)})
file.h5$close_all()