# Korea_Stocks_for_HDF5

이 프로젝트는 LOPES 팀원인 [choosunsick](https://github.com/choosunsick)이 [수집하고 있는 모든 한국 주식(KOSPI, KOSDAQ)](https://github.com/choosunsick/Korea_Stocks)을 HDF5을 이용해서 단 한개 파일로 저장하여 주식 분석을 할 때 손쉽게 사용하고자 시작했습니다.

## 한계점

아쉽게 GitHub는 100MB까지만 올릴 수 있기 때문에, 수집한 전제 주식 자료를 HDF5 파일 형식으로 바꾼 파일을 올리지 못하고 있습니다. 참고:[100 MB push limit](https://help.github.com/en/articles/conditions-for-large-files) 우리 팀에서 HDF5 파일 형식으로 바꿀 때 사용하고 있는 라이프러리에 압축을 도와주는 옵션이 없는 것 같아서 이런 문제가 발생하고 있는 것 같습니다. 이를 찾거나 다른 것을 사용해서 100MB 이하로 줄어든다면 올리도록 하겠습니다.

## 주식 자료 다운 방법

주식 자료를 받기 위해 굳이 이 프로젝트를 `clone` 하실 필요는 없습니다. 현재 이 프로젝트 안에는 KOSPI 200에 들어있는 주식 종목 자료가 들어있는 파일을 있습니다. 이 파일을 다운받으시려면 아래 링크를 가신 다음, `Downdload`버튼을 누르시면, 손쉽게 받으실 수 있습니다.

[https://github.com/LOPES-HUFS/Korea_Stocks_for_HDF5/blob/master/Kospi_200.h5](https://github.com/LOPES-HUFS/Korea_Stocks_for_HDF5/blob/master/Kospi_200.h5)

## 파일 사용법
