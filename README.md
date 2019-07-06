# Korea_Stocks_for_HDF5

이 프로젝트는 LOPES 팀원인 [choosunsick](https://github.com/choosunsick)이 [수집하고 있는 모든 한국 주식(KOSPI, KOSDAQ)](https://github.com/choosunsick/Korea_Stocks)을 HDF5을 이용해서 단 한개 파일로 저장하여 주식 분석을 할 때 손쉽게 사용하고자 시작했습니다.

## 주식 자료 다운 방법

주식 자료를 받기 위해 굳이 이 프로젝트를 `clone` 하실 필요는 없습니다. 현재 이 프로젝트 안에는 2019년 7월 5일까지의 KOSPI와 KOSDAQ 주식 종목 자료가 들어있는 파일을 있습니다. 이 파일을 다운받으시려면 아래 링크를 가신 다음, `Downdload`버튼을 누르시면, 손쉽게 받으실 수 있습니다.

[https://github.com/LOPES-HUFS/Korea_Stocks_for_HDF5/blob/master/all_stock.h5](https://github.com/LOPES-HUFS/Korea_Stocks_for_HDF5/blob/master/all_stock.h5)

## 튜토리얼 코드 - R

아래의 코드는 삼성전자의 주식 종목 데이터를 예시로 HDF5 파일에 입력하고 저장하는 과정입니다. 이후 만든 샘플 파일에서 삼성전자의 데이터를 추출하는 방법입니다.  

```
install.packages("BiocManager")
BiocManager::install("rhdf5")
library(rhdf5)

stock_005930 <- read.csv(file =  "https://raw.githubusercontent.com/LOPES-HUFS/Korea_Stocks_for_HDF5/master/stocks/005930.csv", header = TRUE, stringsAsFactors=FALSE)

stock_005930$Date <- as.integer(paste(substr(stock_005930$Date,1,4),substr(stock_005930$Date,6,7),substr(stock_005930$Date,9,10),sep = ""))

h5createFile("sample.h5")

h5createGroup("sample.h5","KOSPI")

h5write(as.matrix(stock_005930), file="sample.h5",name="KOSPI/005930")

h5write(c("Date","Open","High","Low","Close","Volume","Adj_Close"), file="sample.h5",name="colnames")

sample <- H5Fopen("sample.h5")

samsung_sample <- data.frame(sample$"KOSPI/005930")
colnames(samsung_sample) <- sample$colnames
samsung_sample$Date <- paste(substr(samsung_sample$Date,1,4),"-",substr(samsung_sample$Date,5,6),"-",substr(samsung_sample$Date,7,8),sep = "")
```

## 전체 주식 종목을 HDF5로 만드는 코드 - R

이 코드는 이 프로젝트를 클론하거나 zip으로 받아서 이용해야 합니다. 또한, 다운로드한 주식 파일들을 R의 디렉터리 환경을 다운로드한 파일로 변경해주어야 합니다.

```
h5createFile("all_stock.h5")

create_h5_file <- function(stocknumber){
    file_path <- paste("./stocks",stocknumber,sep="")
    stock_temp <- read.csv(file = file_path, header = TRUE, stringsAsFactors=FALSE)
    stock_temp$Date <- as.integer(paste(substr(stock_temp$Date,1,4),substr(stock_temp$Date,6,7),substr(stock_temp$Date,9,10),sep = ""))
    data_name <- paste("_",stocknumber,sep = "")
    h5createDataset("all_stock.h5", data_name, c(NROW(stock_temp),7),storage.mode = "integer",level=9)
    h5write(as.matrix(stock_temp), file="all_stock.h5",name=data_name)
  }
  
stock_list <- dir("./stocks")
lapply(stock_list,function(x){create_h5_file(x)})

```

## 전체 주식 종목 파일 사용법

전체 주식 종목 파일의 경우에는 코스피와 코스닥의 분류가 없기 때문에 다음과 같이 원하는 주식 종목에 접근해서 사용할 수 있습니다.

```
all_sample <- H5Fopen("all_stock.h5")

samsung_sample <- data.frame(all_sample$"_005930")
colnames(samsung_sample) <- all_sample$colnames
samsung_sample$Date <- paste(substr(samsung_sample$Date,1,4),"-",substr(samsung_sample$Date,5,6),"-",substr(samsung_sample$Date,7,8),sep = "")
```




