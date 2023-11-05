# 📚 "북킵" 나만의 도서관 사서 - 도서관리, 독서기록 [Kor]
For english version click [here](https://www.google.com)

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
![북킵-Home drawio](https://github.com/alexcho617/BookKeep/assets/38528052/758a6479-0439-450c-8dfa-dcd5da542b58)
## ⚠️  트러블슈팅 및 회고
- Realm 변경사항이 Diffable Datasource와 Compositional Layout으로 된 UICollectionView에 제대로 반영되지 않음

	해결방법: dataSource.apply()시점을 조정하여 cellProvider closure 호출

  	[기술 블로그 포스팅](https://velog.io/@alexcho617/Realm-DiffableDataSource)

  	> 핵심 코드
	```swift
	func moveSection(itemToMove: RealmBook,from sourceSection: SectionLayoutKind, to destinationSection: SectionLayoutKind) {
		snapshot.deleteItems([itemToMove])
	    dataSource.apply(snapshot, animatingDifferences: true)
	
		snapshot.appendItems([itemToMove], toSection: destinationSection)
	    dataSource.apply(snapshot, animatingDifferences: true)
	}
	```
 
- 독서 중 비정상 종료시 읽고 있는 책에 대한 데이터가 날라감

	해결방법: Reading View에 UserDefaults를 사용하여 비정상 종료시 독서기록 데이터 보존 및 복구처리


  	[기술 블로그 포스팅](https://velog.io/@alexcho617/UserDefaults-%EA%B8%B0%EB%B0%98%EC%9C%BC%EB%A1%9C-%EC%95%B1-%EC%8B%A4%ED%96%89%EC%8B%9C-%EB%8D%B0%EC%9D%B4%ED%84%B0-%EB%B3%B5%EA%B5%AC-%EB%B6%84%EA%B8%B0%EC%B2%98%EB%A6%AC)

  	<img width="40%" alt="appstore" src="https://velog.velcdn.com/images/alexcho617/post/73bbb63a-ae70-4aad-9904-f4bcd51d5e7e/image.png">

  	> 핵심 코드
	```swift
 	//ReadingViewModel.swift
    func setTimer(){
        timer.countMode = .stopWatch
        timer.defultValue = 0 //시작 값
        timer.effectiveValue = 1 // 단위
        timer.timeInterval = 1 // 주기
        timer.isActiveInBackground = true
        timer.observeElapsedTime = observeTimeHandler(time:)
        UserDefaults.standard.set(isbn, forKey: UserDefaultsKey.LastISBN.rawValue)
        UserDefaults.standard.set(startTime, forKey: UserDefaultsKey.LastStartTime.rawValue)

        mainButtonClicked()
    }
      
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
	    //복구 정보
	    guard let isbn = UserDefaults.standard.object(forKey: UserDefaultsKey.LastISBN.rawValue) as? String else {return}
	    guard let startTime = UserDefaults.standard.object(forKey: UserDefaultsKey.LastStartTime.rawValue) as? Date else {return}
	    guard let readTime = UserDefaults.standard.object(forKey: UserDefaultsKey.LastElapsedTime.rawValue) as? TimeInterval else {return}
	    HomeViewController.printUserDefaultsStatus()
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
- [앱 출시 회고](https://velog.io/@alexcho617/첫-출시-앱-북킵-회고)

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

