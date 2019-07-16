# 패키지 설치 

install.packages("BiocManager")
BiocManager::install("rhdf5")
library(rhdf5)

# 전체 주식 종목 목록 

path_list <- paste("./stocks/",dir("./stocks"),sep = "")

# HDF5 파일 생성 

h5createFile("all_stock.h5")

# 주식 종목 데이터의 열이름 저장

h5write(c("Date","Open","High","Low","Close","Volume","Adj_Close"), "all_stock.h5","colnames")

# 데이터 입력과정 함수화 

create_h5_file<-function(filename){
    stock_temp <- read.csv(file = filename, header = TRUE, stringsAsFactors=FALSE)
    data_name <- paste("kor_",substr(filename,10,15),sep = "")
    stock_temp$Date <- as.integer(gsub("-","",stock_temp$Date))
    h5createDataset(file = "all_stock.h5", dataset = data_name, dims = dim(stock_temp),storage.mode = "integer",level=9)
    h5write(as.matrix(stock_temp), file="all_stock.h5",name=data_name)
    }

# 모든 주식 종목에 대해 반복실행

lapply(path_list,function(x){create_h5_file(x)})
