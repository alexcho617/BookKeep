//
//  MockData.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/26.
//

import Foundation
enum MockData{
    static let sampleImage = "https://image.aladin.co.kr//product//6853//49//cover//8932917248_2.jpg"
    static func booksReading() -> [RealmBook] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let book1 = RealmBook(
            title: "살인자의 기억법",
            ownerId: "1",
            coverUrl: "https://example.com/book1-cover.jpg",
            author: "김영하",
            descriptionOfBook: """
            "살인자의 기억법"은 한국 문학계의 거장, 김영하 작가의 대표작 중 하나입니다. 이 소설은 단순한 범죄 소설이 아닌, 범인의 시선에서 이야기가 풀려나가는 독특한 구성이 특징입니다. 살인범과 경찰, 피해자의 시선에서 서로 다른 이야기가 공존하며, 독자는 각 시각에서 벌어지는 사건을 체험할 수 있습니다. 김영하 작가의 탁월한 문장력과 감정 묘사는 이 작품을 더욱 특별하게 만듭니다.
            """,
            publisher: "문학동네",
            isbn: "9788954617266",
            pageNumber: "350",
            readingStatus: .reading,
            startDate: dateFormatter.date(from: "2023-01-01")!,
            endDate: nil,
            rating: 0,
            currentReadingPage: 50,
            expectScore: 0,
            isDeleted: false
        )
        
        let book2 = RealmBook(
            title: "해를 품은 달",
            ownerId: "2",
            coverUrl: "https://example.com/book2-cover.jpg",
            author: "정은광",
            descriptionOfBook: """
            "해를 품은 달"은 한국 소설의 거장, 정은광 작가의 대표작 중 하나입니다. 이 작품은 귀족과 노예의 운명을 가볍지 않게 다루고 있으며, 사랑, 충성, 복수의 이야기가 복합적으로 얽혀있습니다. 역사적 배경과 인물들의 감정을 섬세하게 그린 이 소설은 독자들에게 깊은 감동을 선사합니다.
            """,
            publisher: "민음사",
            isbn: "9788937472023",
            pageNumber: "420",
            readingStatus: .reading,
            startDate: dateFormatter.date(from: "2023-02-01")!,
            endDate: nil,
            rating: 0,
            currentReadingPage: 70,
            expectScore: 0,
            isDeleted: false
        )
        
        let book3 = RealmBook(
            title: "피와 뼈",
            ownerId: "3",
            coverUrl: "https://example.com/book3-cover.jpg",
            author: "정유정",
            descriptionOfBook: """
            "피와 뼈"은 한국 대중 소설의 명작 중 하나입니다. 이 소설은 한국 전쟁 시기를 배경으로 하며, 가족과 동료, 사랑에 대한 감정을 다룹니다. 작가 정유정의 생생한 문장과 감정 묘사로 독자들에게 강한 감동을 선사하는 이 작품은 여러 상을 수상한 바 있습니다.
            """,
            publisher: "은행나무",
            isbn: "9788994059672",
            pageNumber: "280",
            readingStatus: .reading,
            startDate: dateFormatter.date(from: "2023-03-01")!,
            endDate: nil,
            rating: 0,
            currentReadingPage: 40,
            expectScore: 0,
            isDeleted: false
        )
        
        let book4 = RealmBook(
            title: "백설공주",
            ownerId: "4",
            coverUrl: "https://example.com/book4-cover.jpg",
            author: "그림 협회",
            descriptionOfBook: """
            "백설공주"는 전래동화의 대표작 중 하나로, 전세계 어린이들에게 사랑받는 이야기입니다. 이 동화는 아름다운 공주와 독한 여왕, 아랫집 일곱 난쟁이 등 다양한 캐릭터로 이루어진 독특한 이야기를 담고 있으며, 화려한 그림과 함께 아이들에게 교훈을 전합니다.
            """,
            publisher: "사계절",
            isbn: "9788962210424",
            pageNumber: "32",
            readingStatus: .reading,
            startDate: dateFormatter.date(from: "2023-04-01")!,
            endDate: nil,
            rating: 0,
            currentReadingPage: 5,
            expectScore: 0,
            isDeleted: false
        )
        
        let book5 = RealmBook(
            title: "어린왕자",
            ownerId: "5",
            coverUrl: "https://example.com/book5-cover.jpg",
            author: "앙투안 드 생텍쥐페리",
            descriptionOfBook: """
            "어린왕자"는 세계문학의 걸작 중 하나로, 어린 왕자와 조종사의 이야기를 통해 인생의 무한한 질문을 던지는 작품입니다. 작가 앙투안 드 생텍쥐페리의 철학적 내용과 아름다운 삽화가 독자들에게 영감을 주며, 이 작품을 통해 새로운 시각을 얻을 수 있습니다.
            """,
            publisher: "글항아리",
            isbn: "9788937460242",
            pageNumber: "96",
            readingStatus: .reading,
            startDate: dateFormatter.date(from: "2023-05-01")!,
            endDate: nil,
            rating: 0,
            currentReadingPage: 15,
            expectScore: 0,
            isDeleted: false
        )
        
        return [book1, book2, book3, book4, book5]
    }
    
    
    // Generate mock data for books that will be read
    static func booksToRead() -> [RealmBook] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let book1 = RealmBook(
            title: "죄와 벌",
            ownerId: "1",
            coverUrl: "https://example.com/book1-cover.jpg",
            author: "피천득",
            descriptionOfBook: """
            "죄와 벌"은 러시아 문학의 걸작 중 하나로, 범죄와 벌을 다루는 소설입니다. 대부분의 인물들이 범죄자로서 등장하며, 벌을 받거나 벌을 주는 과정을 통해 인간의 본성과 도덕적 문제를 탐구합니다.
            """,
            publisher: "민음사",
            isbn: "9788937472504",
            pageNumber: "550",
            readingStatus: .toRead,
            startDate: nil,
            endDate: nil,
            rating: 0,
            currentReadingPage: 0,
            expectScore: 0,
            isDeleted: false
        )

        let book2 = RealmBook(
            title: "1984",
            ownerId: "2",
            coverUrl: "https://example.com/book2-cover.jpg",
            author: "조지 오웰",
            descriptionOfBook: """
            "1984"는 미래 사회를 배경으로 한 과학 소설로, 감시와 통제가 주제입니다. 빅 브라더, 뉴스피크, 더블씽크 등의 개념을 소개하며, 개인의 자유와 개인정보 보호를 논의합니다.
            """,
            publisher: "민음사",
            isbn: "9788937487478",
            pageNumber: "400",
            readingStatus: .toRead,
            startDate: nil,
            endDate: nil,
            rating: 0,
            currentReadingPage: 0,
            expectScore: 0,
            isDeleted: false
        )

        let book3 = RealmBook(
            title: "데미안",
            ownerId: "3",
            coverUrl: "https://example.com/book3-cover.jpg",
            author: "헤르만 헤세",
            descriptionOfBook: """
            "데미안"은 자아 탐구와 성장의 과정을 다루는 소설로, 청소년 시절의 고민과 성인이 되는 과정을 그립니다. 주인공 데미안이 자신의 삶과 세계를 탐구하며 도전하는 모습을 통해 자아 발견의 여정을 그립니다.
            """,
            publisher: "민음사",
            isbn: "9788937486181",
            pageNumber: "220",
            readingStatus: .toRead,
            startDate: nil,
            endDate: nil,
            rating: 0,
            currentReadingPage: 0,
            expectScore: 0,
            isDeleted: false
        )

        let book4 = RealmBook(
            title: "호밀밭의 파수꾼",
            ownerId: "4",
            coverUrl: "https://example.com/book4-cover.jpg",
            author: "J.D. 샐린저",
            descriptionOfBook: """
            "호밀밭의 파수꾼"은 청소년의 고독과 무력함, 사회적 불만을 다루는 소설입니다. 주인공 홀덴 코필드의 내면 고백을 통해 성장과 아픔을 그립니다.
            """,
            publisher: "민음사",
            isbn: "9788937486686",
            pageNumber: "240",
            readingStatus: .toRead,
            startDate: nil,
            endDate: nil,
            rating: 0,
            currentReadingPage: 0,
            expectScore: 0,
            isDeleted: false
        )

        let book5 = RealmBook(
            title: "노르웨이의 숲",
            ownerId: "5",
            coverUrl: "https://example.com/book5-cover.jpg",
            author: "하루키 무라카미",
            descriptionOfBook: """
            "노르웨이의 숲"은 청춘과 사랑, 소외와 죽음을 그리는 소설로, 일본 문학의 대표작 중 하나입니다. 주인공 와타나베의 시선에서 풀려나가는 이야기는 청춘의 아름다움과 상실을 그립니다.
            """,
            publisher: "민음사",
            isbn: "9788937484897",
            pageNumber: "350",
            readingStatus: .toRead,
            startDate: nil,
            endDate: nil,
            rating: 0,
            currentReadingPage: 0,
            expectScore: 0,
            isDeleted: false
        )

        let book6 = RealmBook(
            title: "빨강머리 앤",
            ownerId: "6",
            coverUrl: "https://example.com/book6-cover.jpg",
            author: "루시 모드 몽고메리",
            descriptionOfBook: """
            "빨강머리 앤"은 캐나다 문학의 명작 중 하나로, 빨강머리 소녀 앤의 성장 이야기를 다룹니다. 앤은 활기차고 밝은 성격으로 주변 사람들에게 사랑을 받으며 여러 모험과 이야기를 펼칩니다.
            """,
            publisher: "민음사",
            isbn: "9788937484903",
            pageNumber: "320",
            readingStatus: .toRead,
            startDate: nil,
            endDate: nil,
            rating: 0,
            currentReadingPage: 0,
            expectScore: 0,
            isDeleted: false
        )

        let book7 = RealmBook(
            title: "죄와 벌",
            ownerId: "7",
            coverUrl: "https://example.com/book7-cover.jpg",
            author: "피천득",
            descriptionOfBook: """
            "죄와 벌"은 러시아 문학의 걸작 중 하나로, 범죄와 벌을 다루는 소설입니다. 대부분의 인물들이 범죄자로서 등장하며, 벌을 받거나 벌을 주는 과정을 통해 인간의 본성과 도덕적 문제를 탐구합니다.
            """,
            publisher: "민음사",
            isbn: "9788937472504",
            pageNumber: "550",
            readingStatus: .toRead,
            startDate: nil,
            endDate: nil,
            rating: 0,
            currentReadingPage: 0,
            expectScore: 0,
            isDeleted: false
        )

        let book8 = RealmBook(
            title: "1984",
            ownerId: "8",
            coverUrl: "https://example.com/book8-cover.jpg",
            author: "조지 오웰",
            descriptionOfBook: """
            "1984"는 미래 사회를 배경으로 한 과학 소설로, 감시와 통제가 주제입니다. 빅 브라더, 뉴스피크, 더블씽크 등의 개념을 소개하며, 개인의 자유와 개인정보 보호를 논의합니다.
            """,
            publisher: "민음사",
            isbn: "9788937487478",
            pageNumber: "400",
            readingStatus: .toRead,
            startDate: nil,
            endDate: nil,
            rating: 0,
            currentReadingPage: 0,
            expectScore: 0,
            isDeleted: false
        )

        let book9 = RealmBook(
            title: "데미안",
            ownerId: "9",
            coverUrl: "https://example.com/book9-cover.jpg",
            author: "헤르만 헤세",
            descriptionOfBook: """
            "데미안"은 자아 탐구와 성장의 과정을 다루는 소설로, 청소년 시절의 고민과 성인이 되는 과정을 그립니다. 주인공 데미안이 자신의 삶과 세계를 탐구하며 도전하는 모습을 통해 자아 발견의 여정을 그립니다.
            """,
            publisher: "민음사",
            isbn: "9788937486181",
            pageNumber: "220",
            readingStatus: .toRead,
            startDate: nil,
            endDate: nil,
            rating: 0,
            currentReadingPage: 0,
            expectScore: 0,
            isDeleted: false
        )

        let book10 = RealmBook(
            title: "호밀밭의 파수꾼",
            ownerId: "10",
            coverUrl: "https://example.com/book10-cover.jpg",
            author: "J.D. 샐린저",
            descriptionOfBook: """
            "호밀밭의 파수꾼"은 청소년의 고독과 무력함, 사회적 불만을 다루는 소설입니다. 주인공 홀덴 코필드의 내면 고백을 통해 성장과 아픔을 그립니다.
            """,
            publisher: "민음사",
            isbn: "9788937486686",
            pageNumber: "240",
            readingStatus: .toRead,
            startDate: nil,
            endDate: nil,
            rating: 0,
            currentReadingPage: 0,
            expectScore: 0,
            isDeleted: false
        )

        return [book1, book2, book3, book4, book5, book6, book7, book8, book9, book10]
    }

    
  
}
