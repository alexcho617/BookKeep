# 📚 "북킵" 나만의 도서관 사서 - 도서관리, 독서기록
<img width="1352" alt="appstore" src="https://github.com/alexcho617/BookKeep/assets/38528052/3c135ddb-18cd-4002-a7a0-5edbe04826a0">

<br>

<img width="128" alt="primary" src="https://github.com/alexcho617/BookKeep/assets/38528052/567969a2-bf8f-44d5-b07b-62d158956352">

[🔗 앱스토어 바로가기](https://apps.apple.com/kr/app/%EB%B6%81%ED%82%B5-%EB%8F%84%EC%84%9C%EA%B4%80%EB%A6%AC-%EB%8F%85%EC%84%9C%EA%B8%B0%EB%A1%9D/id6469721694)

## ⭐ 프로젝트 소개
북킵은 관심있는 책을 추가하고 도서를 상태별로 관리하며 독서기록과 메모를 남기는 앱입니다. Aladin API로 새로운 책을 추가하고 `enum`으로 책 상태를 관리합니다. 또한 `timer`를 사용하여 몰입감있는 독서 경험을 선사하며 독서기록과 메모를 `CRUD`할 수 있습니다.
<br>

## 📆  개발 기간
2023.10.01 ~ 2023.10.21 (3주 코어 타임, 이후 꾸준히 업데이트 중)
<br>

## 🛠️ 기술스택
UIKit / MVVM / RxSwift / Realm / Kingfisher / Alamofire  / Open API / Crashlytics
<br>

## 🍎 주요기능

> Aladin Open API를 사용한 도서 검색 및 추가 | 페이지네이션 적용
<img width="774" alt="image" src="https://github.com/alexcho617/BookKeep/assets/38528052/ec2e6adb-25e6-4c6e-af09-7351ee1b394c">
<br>

> Enum을 사용한 도서상태 관리 | Compositional Layout 사용
<img width="1154" alt="image" src="https://github.com/alexcho617/BookKeep/assets/38528052/9809e4e2-4472-4e84-b77c-c36a42f1d9ed">

> Timer를 사용한 독서 기록 | UserDefaults로 비정상 종료 대응
<img width="766" alt="image" src="https://github.com/alexcho617/BookKeep/assets/38528052/cca43f74-9f46-4766-8078-77e9e8c345a1">

> 도서별 메모 추가 및 관리 | Realm Nested Table 사용
<img width="766" alt="image" src="https://github.com/alexcho617/BookKeep/assets/38528052/927cd267-be86-469d-9056-67cf3bc101db">

<br>

## 📦 개발환경
Swift 5.8 / Xcode 14.3 / SnapKit 5.6 / Kingfisher 7.9 / Alamofire 5.8 / Realm 10.42

## 🎯 배포타겟
iOS 16.0

## ⚠️  트러블슈팅 및 회고

- [MVVM에서 Realm을 구독하고 DiffableDataSource와CompositionalLayout 적용하기](https://velog.io/@alexcho617/Realm-DiffableDataSource)

- [출시 회고](https://velog.io/@alexcho617/첫-출시-앱-북킵-회고)

