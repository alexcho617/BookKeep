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
    //MARK: 일단은 PK로 ObjectID 대신 String을 쓴 후 추후에 개선을 해보자.
    @Persisted(primaryKey: true) var isbn: String
    @Persisted()var title: String = ""
    @Persisted var coverUrl: String = ""
    @Persisted var author: String = ""
    @Persisted var descriptionOfBook: String = ""
    @Persisted var publisher: String = ""
    @Persisted var page: Int = 0
    
    //app exclusive
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
    @Persisted var endTime: Date = .now
    @Persisted var endPage: Int = 0
    @Persisted var duration: Int = 0
    @Persisted(originProperty: "readSessions") var ofBook: LinkingObjects<RealmBook>
}

class Memo: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var date: Date = .now
    @Persisted var contents: String = ""
    @Persisted var photo: String = ""
    @Persisted(originProperty: "memos") var ofBook: LinkingObjects<RealmBook>
    
    
}

