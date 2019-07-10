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

