# Korea_Stocks_for_HDF5

이 프로젝트는 LOPES 팀원인 [choosunsick](https://github.com/choosunsick)이 [수집하고 있는 모든 한국 주식(KOSPI, KOSDAQ)](https://github.com/choosunsick/Korea_Stocks)을 HDF5 형식을 이용해서 단 한개 파일로 저장하여 주식 분석을 할 때 손쉽게 사용하고자 시작했습니다. 
모든 주식 종목 데이터를 한 개의 파일로 저장해 사용한다면, 필요한 주식 종목 데이터들을 따로 모을 필요가 없으며, 주식 데이터를 분석할 때 개별 주식 종목의 파일을 따로 읽어올 필요도 없어집니다. 이런 편리함을 위해 R로 모든 주식 종목 자료들을 100MB 이하의 HDF5 파일 하나로 저장하는 방법에 대해 소개합니다.

## HDF5 형식 소개 
이 HDF 파일은 계층적 데이터 형식(Hierarchical Data Format)이란 이름을 가진 데이터 저장 형식입니다. 이 형식은 이름 그대로 데이터를 계층을 나누어 저장합니다. 이 형식의 최신 버전인 HDF5는 [HDF그룹](https://www.hdfgroup.org/solutions/hdf5/)에서 관리하고 있습니다. HDF5 형식의 장점은 대용량의 파일들을 작은 용량의 파일 하나로 만들 수 있다는 장점과 R 이나 Python 등에서도 쉽게 호환되어 사용할 수 있다는 장점이 있습니다. HDF5 형식에 대해 좀 더 자세히 알고 싶다면 [링크](https://support.hdfgroup.org/HDF5/whatishdf5.html)를 참조해주시기 바랍니다. 

## 전체 주식 자료 다운 방법

전체 주식 자료를 받기 위해 굳이 이 프로젝트를 `clone` 하실 필요는 없습니다. 현재 이 프로젝트 안에는 2019년 7월 9일까지의 KOSPI와 KOSDAQ 주식 종목 자료가 들어있는 파일을 있습니다. 이 파일을 다운받으시려면 아래 링크를 가신 다음, `Downdload`버튼을 누르시면, 손쉽게 받으실 수 있습니다.

[https://github.com/LOPES-HUFS/Korea_Stocks_for_HDF5/blob/master/all_stock.h5](https://github.com/LOPES-HUFS/Korea_Stocks_for_HDF5/blob/master/all_stock.h5)

## 필요 패키지 설치 및 HDF5 파일 읽기

필수적인 패키지인 "rhdf5"를 설치해줍니다. 패키지 설치가 완료되었으면 전체 주식 종목이 담긴 HDF5 파일을 R로 읽어와 줍니다. R에서 "all_stock.h5" 파일을 읽어올 때 본인의 R 디렉터리 내에 파일을 넣어주어야 읽어오는 과정에서 오류가 발생하지 않습니다.  

```
install.packages("BiocManager")
BiocManager::install("rhdf5")
library(rhdf5)

all_sample <- H5Fopen("all_stock.h5")

```

## HDF5 파일 사용 예시

이제 위에서 읽어온 파일을 사용하는 방법에 대해 소개하겠습니다. 예를 들어 전체 주식 종목 중 삼성전자의 데이터를 뽑아서 캔들차트를 그려봅시다. 데이터를 직접 사용하실 때에는 아래 코드 중 `data.frame(all_sample$kor_005930)` 코드의 "kor_005930" 부분을 "kor_원하는 주식 종목의 코드" 로 변경하면 원하는 주식 종목 데이터를 얻으실 수 있습니다. 

```
# 필요 패키지 설치

install.packages("dygraphs")
install.packages("tidyverse")
install.packages("xts")

library(dygraphs)
library(tidyverse)
library(xts)

# 읽어온 HDF5 파일에서 삼성전자 데이터 뽑아내기

samsung_sample <- data.frame(all_sample$kor_005930)
colnames(samsung_sample) <- all_sample$colnames
samsung_sample$Date <- paste(substr(samsung_sample$Date,1,4),"-",substr(samsung_sample$Date,5,6),"-",substr(samsung_sample$Date,7,8),sep = "")

head(samsung_sample)

# 캔들 차트 그려보기 

newTemp <- select(samsung_sample, "Open", "High", "Low", "Close")
rownames(newTemp) <- samsung_sample$Date
newTemp <- as.xts(newTemp)
dygraph(newTemp['2019'],main = "candlestick",group = "stock_graph") %>% dyRangeSelector() %>% dyCandlestick() 

```
위의 코드를 통해 삼성전자의 2019년도 데이터를 기준으로 candle chart를 그리면 다음과 같은 결과를 얻을 수 있습니다. 
![candlechart_005930](https://user-images.githubusercontent.com/19144813/60954387-d7c53600-a339-11e9-9629-59f9a3b253f1.png)


## 참고사항

R을 사용해 전체 주식 종목의 HDF5 파일을 만드는 방법은 [링크](https://choosunsick.github.io/post/stockdata_to_hdf5/)의 글이나 이 깃허브의 [R 스크립트의 코드](https://github.com/LOPES-HUFS/Korea_Stocks_for_HDF5/blob/master/rhdf5%20compression.R)를 통해 확인하실 수 있습니다. 

전체 주식 종목 데이터를 저장하는 파일인 "all_stock.h5" 파일은 일주일을 단위로 갱신될 것입니다. 깃허브에서는 아쉽게 GitHub는 100MB까지만 올릴 수 있기 때문에, 시간이 흘러 수집한 주식 자료가 더 방대해져 "all_stock.h5" 파일의 크기가 100MB가 넘어가게 될 경우 업데이트가 진행되지 않을 수 있습니다. 참고:[100 MB push limit](https://help.github.com/en/articles/conditions-for-large-files) 
