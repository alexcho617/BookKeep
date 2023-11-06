# 📚 "북킵" 나만의 도서관 사서 - 도서관리, 독서기록

<img width="128" alt="primary" src="https://github.com/alexcho617/BookKeep/assets/38528052/36ed9eb9-64fd-45ca-a39e-bae904ad4cd9">


[🔗 앱스토어 바로가기](https://apps.apple.com/kr/app/%EB%B6%81%ED%82%B5-%EB%8F%84%EC%84%9C%EA%B4%80%EB%A6%AC-%EB%8F%85%EC%84%9C%EA%B8%B0%EB%A1%9D/id6469721694)

<img width="2163" alt="appstore" src="https://github.com/alexcho617/BookKeep/assets/38528052/e5ff3f8d-8a2f-4cd6-a16b-003e277e540e">

## ⭐ 프로젝트 소개
북킵은 관심있는 책을 추가하고 도서를 상태별로 관리하며 독서기록과 메모를 남기는 앱입니다. Aladin API로 새로운 책을 추가하고 `enum`으로 책 상태를 관리합니다. 또한 `timer`를 사용하여 몰입감있는 독서 경험을 선사하며 독서기록과 메모를 `CRUD`할 수 있습니다.
<br>

## 👤 개발 인원
개인 프로젝트
<br>

## 📆 개발 기간
2023.10.01 ~ 2023.10.21 (3주, 이후 꾸준히 업데이트 중)
<br>

## 🛠️ 기술스택
UIKit / MVVM / RxSwift / Realm / Kingfisher / Alamofire  / Open API / Crashlytics
<br>

## 📦 개발환경 & 타겟
- Swift 5.8 / Xcode 14.3 / SnapKit 5.6 / Kingfisher 7.9 / Alamofire 5.8 / Realm 10.42
- iOS 16.0

## 🤔  개발하며 고민한 점
### Modern CollectionView 구현
<img width="75%" alt="image" src="https://github.com/alexcho617/BookKeep/assets/38528052/758a6479-0439-450c-8dfa-dcd5da542b58">

HomeView의 UICollectionView를 구성할때 Diffable Datasource와 Compositional Layout을 통해 index가 아닌 cell data를 기반으로 cell을 구성했습니다.

```swift
dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, RealmBook>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
let status = itemIdentifier.readingStatus
switch status {
	case .reading:
	    return collectionView.dequeueConfiguredReusableCell(using: readingCellRegistration, for: indexPath, item: itemIdentifier)
    case .toRead:
    	return collectionView.dequeueConfiguredReusableCell(using: toReadCellRegistration, for: indexPath, item: itemIdentifier)
    default:
	    return collectionView.dequeueConfiguredReusableCell(using: toReadCellRegistration, for: indexPath, item: itemIdentifier)
    }
```

### URLRequestConvertible 프로토콜을 채택한 Router패턴으로 REST API 네트워킹

API통신은 Alamofire를 사용했는데 일전에 GCD와 URLSession data task를 사용한 통신은 해봤기 때문에 이번 프로젝트에선 Alamofire를 사용했습니다. Alamofire의 responseDecodable를 통해 JSONDecoder보다 더욱 편리하게 JSON응답을 처리 할 수 있었고 Result<Success, Failure>를 통해 명시적으로 통신 처리를 할 수 있었습니다.

```swift
class NetworkManager{
...
	func requestConvertible<T: Decodable>(type: T.Type, api: AladinRouter, completion: @escaping (Result<T, AFError>) -> Void){
	    AF.request(api).responseDecodable(of: T.self) { response in
	        switch response.result{
	        case .success(let data):
	            completion(.success(data))
	        case .failure(let error):
	            completion(.failure(error))
	        }
	    }
	}
}
```

또한 Router패턴과 URLRequestConvertible프로토콜을 채택하여서 확장성과 유지보수에 좋은 코드를 쓰기위해 노력했습니다.

```swift
enum AladinRouter: URLRequestConvertible{
...
	func asURLRequest() throws -> URLRequest {
	    let timeoutInterval: TimeInterval = 5
	    let url = baseURL.appendingPathComponent(path)
	    var request = URLRequest(url: url)
	    request.method = method
	    request.timeoutInterval = timeoutInterval
	    request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(queries, into: request)
	    return request
	}
}
```

### DataSource Prefetching적용하여 API콜 절약

사용자의 책 검색 Use Case에서 검색 결과를 몇개까지 보여줘야 하는가에 대한 고민을 하였습니다. 약 10명의 베타 테스트 플라잇 사용자들을 조사한 결과 제목이 너무 모호하지만 않으면 보통 60개 안에는 나오는 것을 확인할 수 있었고 만약에 대비해 이것의 2배인 120개의 결과를 보여주도록 설정했습니다.

하지만 120개의 결과를 검색시 바로 UI에 보여주는것은 불필요하고 앱의 성능에도 영향을 미칠 수 있는 부분이라 생각되어 Prefetching을 적용하였고 API호출 시 페이지 값을 같이 전달하여 구현했습니다. 또한 스크롤 하단 끝 약 2/3 지점에서 다음 페이지를 불러오는것이 일반적인 Use Case에 적합했습니다. 

이에 맞추어 CollectionView에 activityIndicator를 달아주어 검색이 진행되는 동안 사용자에게 시각적 인지를 주었습니다.

```swift
func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    for indexPath in indexPaths {
        let currentRow = indexPath.row
        guard vm.searchResult.value != nil else {return} //검색 값 확인
        guard let count = vm.searchResult.value?.item.count else {return} //검색 값 내에 아이템이 있는지 확인
        guard let totalResults = vm.searchResult.value?.totalResults else {return} //총 검색 결과 확인: 보통 몇백 몇천
        
        if count - 11 == currentRow && count < totalResults && count < 90{ //3번 호출 제한, 최대 120개 결과까지
            activityIndicator.startAnimating()
            vm.searchBook(query: searchBar.text) {
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
```
### NLC를 사용한 여러 네트워크 시나리오에서 UI대응

모바일 기기 특성상 네트워크가 불안정 할 수 있기 때문에 Network Link Connector 를 사용하여 패킷이 100% Loss 되는 경우, 3G 속도, High Latency DNS 등 다양한 시나리오 속에서 앱을 테스트하여 QA를 높혔습니다.

Request 타임아웃은 5초로 설정하였고 View에서는 Toast 메시지를 띄워 대응하였습니다. Alamofire를 사용하였기 때문에 비교적 수월하게 네트워크 에러 처리를 할 수 있었고 적절한 라이브러리 사용으로 인해 작업 효율을 높혔습니다.

```swift
//SearchViewController.swift
func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
...
  activityIndicator.startAnimating() //인티케이터 시작

  //ViewModel에서 에러 대응 클로저 실행
  vm.errorHandler = { [weak self] in
		//인티케이터 정지 후 토스트 띄움
      self?.activityIndicator.stopAnimating()
      self?.dismiss(animated: true,completion: {
          let toast = Toast.text("⚠️네트워크 환경이 좋지 못합니다")
          toast.show(haptic: .error)
      })
      
  }
}

```
## ⚠️  트러블슈팅
### Realm 변경사항이 Diffable Datasource와 Compositional Layout으로 된 UICollectionView에 제대로 반영되지 않음
해결방법: dataSource.apply()시점을 조정하여 cellProvider closure 호출

> 핵심 코드
```swift
func moveSection(itemToMove: RealmBook,from sourceSection: SectionLayoutKind, to destinationSection: SectionLayoutKind) {
	snapshot.deleteItems([itemToMove])
    dataSource.apply(snapshot, animatingDifferences: true)

	snapshot.appendItems([itemToMove], toSection: destinationSection)
    dataSource.apply(snapshot, animatingDifferences: true)
}
```
[기술 블로그 포스팅 - Velog](https://velog.io/@alexcho617/Realm-DiffableDataSource)

 
### 독서 중 비정상 종료시 데이터 휘발됨

해결방법: Reading View에 UserDefaults를 사용하여 비정상 종료시 독서기록 데이터 보존 및 복구처리

> 핵심 코드
```swift
//ReadingViewModel.swift

func observeTimeHandler(time: TimeInterval) -> Void{
//update view
elapsedTime.value = time
//1초마다 저장
UserDefaults.standard.set(elapsedTime.value, forKey: UserDefaultsKey.LastElapsedTime.rawValue)
}
```

```swift
//HomeViewController.swift
if UserDefaults.standard.object(forKey: UserDefaultsKey.LastReadingState.rawValue) != nil{
...    
    self.showActionAlert(title: "독서 기록 복구", message: "저장하지 않은 독서기록을 불러오시겠습니까?") {
	//alert action present ReadCompleteVC
	let vc = ReadCompleteViewController()
	vc.isbn = isbn
	vc.startTime = startTime
	vc.readTime = readTime
	vc.navigationHandler = {
	    self.reloadCollectionView()
	}
	if let sheet = vc.sheetPresentationController{
	    sheet.detents = [.medium(), .large()]
	    sheet.prefersGrabberVisible = true
	}
	self.present(vc, animated: true, completion: nil)
	
    }

}

```

<img width="75%" alt="appstore" src="https://github.com/alexcho617/BookKeep/assets/38528052/7efc2b85-e14d-46fe-92b5-bbaf518acddc">

[기술 블로그 포스팅 - Velog](https://velog.io/@alexcho617/UserDefaults-%EA%B8%B0%EB%B0%98%EC%9C%BC%EB%A1%9C-%EC%95%B1-%EC%8B%A4%ED%96%89%EC%8B%9C-%EB%8D%B0%EC%9D%B4%ED%84%B0-%EB%B3%B5%EA%B5%AC-%EB%B6%84%EA%B8%B0%EC%B2%98%EB%A6%AC)

## 🐾 회고
[[iOS] 북킵: 출시 회고 - Velog](https://velog.io/@alexcho617/첫-출시-앱-북킵-회고)

## 🍎 기능상세
> Aladin Open API를 사용한 도서 검색 및 추가 | 페이지네이션 적용
<img width="60%" alt="image" src="https://github.com/alexcho617/BookKeep/assets/38528052/ec2e6adb-25e6-4c6e-af09-7351ee1b394c">
<br><br>

> Enum을 사용한 도서상태 관리 | Compositional Layout 사용
<img width="90%" alt="image" src="https://github.com/alexcho617/BookKeep/assets/38528052/9809e4e2-4472-4e84-b77c-c36a42f1d9ed">
<br><br>

> Timer를 사용한 독서 기록 | UserDefaults로 비정상 종료 대응
<img width="60%" alt="image" src="https://github.com/alexcho617/BookKeep/assets/38528052/cca43f74-9f46-4766-8078-77e9e8c345a1">
<br><br>

> 도서별 메모 추가 및 관리 | Realm Nested Table 사용
<img width="60%" alt="image" src="https://github.com/alexcho617/BookKeep/assets/38528052/927cd267-be86-469d-9056-67cf3bc101db">
<br>

