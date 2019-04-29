library(hdf5r)

savename <- "test_all_stocks.h5" #Name of file to create
file.h5 <- H5File$new(savename, mode="w")

check_dtype<-function(filename){
    stock_temp <- read.csv(file = filename, header = TRUE, stringsAsFactors=FALSE)
    if(guess_dtype(as.matrix(stock_temp[,2:7]))$to_text()!="H5T_STD_I32LE"){
        temp<-data.frame(code=substr(filename,10,15),type=guess_dtype(as.matrix(stock_temp[,2:7]))$to_text())
    }
return(temp)
}
lapply(path_list,function(x){check_dtype(x)})

compression_create_h5_file<-function(filename){
    stock_temp <- read.csv(file = filename, header = TRUE, stringsAsFactors=FALSE)
    data_name <- paste("_",substr(filename,10,15),sep = "")
    stock.grp <- file.h5$create_group(data_name)
    ds_create_pl_nbit <- H5P_DATASET_CREATE$new()
    ds_create_pl_nbit$set_chunk(c(NROW(stock_temp), 6))$set_nbit()
    ds_space <- H5S$new(dims = c(NROW(stock_temp), 6), maxdims = c(Inf, 6))
    if(guess_dtype(as.matrix(stock_temp[,2:7]))$to_text()=="H5T_STD_I32LE"){
        test_ds<-stock.grp$create_dataset(name = "data",dtype = h5types$H5T_STD_I32LE,dataset_create_pl = ds_create_pl_nbit,chunk_dims = c(NROW(stock_temp), 6),gzip_level = 9,space = ds_space)
    }
    else{
        test_ds<-stock.grp$create_dataset(name = "data",dtype = h5types$H5T_IEEE_F64LE,dataset_create_pl = ds_create_pl_nbit,chunk_dims = c(NROW(stock_temp), 6),gzip_level = 9,space = ds_space)
    }
    index_ds<-stock.grp$create_dataset(name = "index",robj = as.matrix(stock_temp[,1]),chunk_dims = c(NROW(stock_temp), 1),gzip_level = 9,space = H5S$new(dims = c(NROW(stock_temp), 1), maxdims = c(Inf, 1)))
    test_ds[,] <- as.matrix(stock_temp[,2:7])
    h5attr(test_ds,"colnames") <- colnames(stock_temp)[2:7]
    h5attr(index_ds,"colnames") <- colnames(stock_temp)[1]
}
lapply(path_list,function(x){compression_create_h5_file(x)})


stock.grp <- file.h5$create_group("_005930")
stock.grp$create_dataset("data",robj = as.matrix(stock_005930[,2:7]),chunk_dims = "auto",gzip_level = 9)
stock.grp$create_dataset("index",robj = as.matrix(stock_005930[,1]),chunk_dims = "auto",gzip_level = 9)
h5attr(stock.grp[["data"]], "colnames") <- colnames(stock_temp)[2:7]
h5attr(stock.grp[["index"]], "colnames") <- colnames(stock_temp)[1]

#테스트
stock.grp$create_dataset("data",robj = as.matrix(stock_066570[,2:7]),chunk_dims = "auto",gzip_level = 9,space = H5S$new(dims = c(NROW(stock_066570), 6), maxdims = c(Inf, 6)))
stock.grp$create_dataset("index",robj = as.matrix(stock_005930[,1]),chunk_dims = "auto",gzip_level = 9,space = H5S$new(dims = c(NROW(stock_005930), 1), maxdims = c(Inf, 1)))
# test 청크사이즈

stock.grp <- file.h5$create_group("test_005930")
ds_create_pl_nbit <- H5P_DATASET_CREATE$new()
ds_create_pl_nbit$set_chunk(c(NROW(stock_005930), 6))$set_nbit()

guess_dtype(as.matrix(stock_005930[,2:7]))
test_ds<-stock.grp$create_dataset(name = "data",dtype = h5types$H5T_STD_I32LE,dataset_create_pl = ds_create_pl_nbit,chunk_dims = c(NROW(stock_005930), 6),gzip_level = 9,space = H5S$new(dims = c(NROW(stock_005930), 6), maxdims = c(Inf, 6)))
test_ds[,] <- as.matrix(stock_005930[,2:7])
h5attr(test_ds,"colnames") <- colnames(stock_005930)[2:7]

ds_create_pl_nbit <- H5P_DATASET_CREATE$new()
ds_create_pl_nbit$set_chunk(c(NROW(stock_005930), 1))$set_nbit()

test_ds<-stock.grp$create_dataset(name = "index",dtype = H5T_STRING$new(size = 10),dataset_create_pl = ds_create_pl_nbit,chunk_dims = c(NROW(stock_005930), 1),gzip_level = 9,space = H5S$new(dims = c(NROW(stock_005930), 1), maxdims = c(Inf, 1)))
test_ds[,] <- as.matrix(stock_005930[,1])
h5attr(test_ds,"colnames") <- colnames(stock_005930)[1]
