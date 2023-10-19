//
//  RealmBook.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/26.
//

import Foundation
import RealmSwift

enum RealmReadStatus: String, PersistableEnum, Hashable{
    case done
    case reading
    case toRead
    case paused
    case stopped
}

final class RealmBook: Object {
    //from API
    @Persisted(primaryKey: true) var isbn: String
    @Persisted()var title: String = ""
    @Persisted var coverUrl: String = ""
    @Persisted var author: String = ""
    @Persisted var descriptionOfBook: String = ""
    @Persisted var publisher: String = ""
    @Persisted var page: Int = 0
    
    
    //app exclusive
    //TODO: 완독횟수 readIteration: Int 추가 - CRUD 전체 변경해야함 브렌치 따로 팔 것
    @Persisted var readingStatus: RealmReadStatus = .toRead
    @Persisted var startDate: Date = .now
    @Persisted var endDate: Date = .now
    @Persisted var rating: Int = 0
    @Persisted var currentReadingPage: Int = 0
    @Persisted var expectScore: Int = 0
    @Persisted var isDeleted: Bool = false
    
    //Relationship Properties
    @Persisted var readSessions: List<ReadSession>
    @Persisted var memos: List<Memo>
    
    convenience init(isbn: String, title: String, coverUrl: String, author: String, descriptionOfBook: String, publisher: String, page: Int) {
        self.init()
        self.isbn = isbn
        self.title = title
        self.coverUrl = coverUrl
        self.author = author
        self.descriptionOfBook = descriptionOfBook
        self.publisher = publisher
        self.page = page
    }
}

class ReadSession: Object{
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var startTime: Date = .now
    @Persisted var endPage: Int = 0
    @Persisted var duration: Double = 0
    @Persisted(originProperty: "readSessions") var ofBook: LinkingObjects<RealmBook>
    
    convenience init(startTime: Date, endPage: Int, duration: Double) {
        self.init()
        self.startTime = startTime
        self.endPage = endPage
        self.duration = duration
    }
}

class Memo: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var date: Date = .now
    @Persisted var contents: String = ""
    @Persisted var photo: String = ""
    @Persisted(originProperty: "memos") var ofBook: LinkingObjects<RealmBook>
    
    convenience init(date: Date, contents: String, photo: String) {
        self.init()
        self.date = date
        self.contents = contents
        self.photo = photo
    }
    
    
}

extension RealmBook {
    func calculateTotalReadTime() -> TimeInterval {
        let totalTimeInterval = readSessions.reduce(0) { $0 + Double($1.duration) }
        return totalTimeInterval
    }
}
