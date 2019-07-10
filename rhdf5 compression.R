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
    stock_temp$Date <- as.integer(paste(substr(stock_temp$Date,1,4),substr(stock_temp$Date,6,7),substr(stock_temp$Date,9,10),sep = ""))
    h5createDataset(file = "all_stock.h5", dataset = data_name, dims = c(NROW(stock_temp),7),storage.mode = "integer",level=9)
    h5write(as.matrix(stock_temp), file="all_stock.h5",name=data_name)
    }

# 모든 주식 종목에 대해 반복실행

lapply(path_list,function(x){create_h5_file(x)})


# HDF5 파일을 읽어와 캔들차트 그리는 방법
    
install.packages("dygraphs")
install.packages("tidyverse")
install.packages("xts")

library(dygraphs)
library(tidyverse)
library(xts)

# HDF5 파일 열기

all_sample <- H5Fopen("all_stock.h5")

# 삼성전자 데이터 뽑아내기

samsung_sample <- data.frame(all_sample$kor_005930)
colnames(samsung_sample) <- all_sample$colnames
samsung_sample$Date <- paste(substr(samsung_sample$Date,1,4),"-",substr(samsung_sample$Date,5,6),"-",substr(samsung_sample$Date,7,8),sep = "")

samsung_sample

# 캔들 차트

newTemp <- select(samsung_sample, "Open", "High", "Low", "Close")
rownames(newTemp) <- samsung_sample$Date
newTemp <- as.xts(newTemp)
dygraph(newTemp['2019'],main = "candlestick",group = "stock_graph") %>% dyRangeSelector() %>% dyCandlestick() 

# 거래량 그래프

temp <- select(samsung_sample, "Volume")
rownames(temp) <- samsung_sample$Date
temp <- as.xts(temp)
dygraph(temp['2019'],main = "volume",group = "stock_graph") %>% dyBarChart()

