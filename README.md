# Korea_Stocks_for_HDF5

이 프로젝트는 LOPES 팀원인 [choosunsick](https://github.com/choosunsick)이 [수집하고 있는 모든 한국 주식(KOSPI, KOSDAQ)](https://github.com/choosunsick/Korea_Stocks)을 HDF5을 이용해서 단 한개 파일로 저장하여 주식 분석을 할 때 손쉽게 사용하고자 시작했습니다.

## 전체 주식 자료 다운 방법

전체 주식 자료를 받기 위해 굳이 이 프로젝트를 `clone` 하실 필요는 없습니다. 현재 이 프로젝트 안에는 2019년 7월 5일까지의 KOSPI와 KOSDAQ 주식 종목 자료가 들어있는 파일을 있습니다. 이 파일을 다운받으시려면 아래 링크를 가신 다음, `Downdload`버튼을 누르시면, 손쉽게 받으실 수 있습니다.

[https://github.com/LOPES-HUFS/Korea_Stocks_for_HDF5/blob/master/all_stock.h5](https://github.com/LOPES-HUFS/Korea_Stocks_for_HDF5/blob/master/all_stock.h5)

## 전체 주식 종목 파일 사용법

전체 주식 종목 파일의 경우에는 코스피와 코스닥의 분류가 없기 때문에 다음과 같이 원하는 주식 종목에 접근해서 사용할 수 있습니다.

```
all_sample <- H5Fopen("all_stock.h5")

samsung_sample <- data.frame(all_sample$"_005930")
colnames(samsung_sample) <- all_sample$colnames
samsung_sample$Date <- paste(substr(samsung_sample$Date,1,4),"-",substr(samsung_sample$Date,5,6),"-",substr(samsung_sample$Date,7,8),sep = "")
```
