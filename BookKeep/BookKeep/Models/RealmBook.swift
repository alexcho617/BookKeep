//
//  RealmBook.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/26.
//

import Foundation
import RealmSwift

enum RealmReadStatus: String, PersistableEnum{
    case done
    case reading
    case toRead
    case paused
    case stopped
}

class RealmBook: Object {
    //from API
    @Persisted(primaryKey: true) var isbn: String
    @Persisted var title: String = ""
    @Persisted var ownerId: String = ""
    @Persisted var coverUrl: String = ""
    @Persisted var author: String = ""
    @Persisted var descriptionOfBook: String = ""
    @Persisted var publisher: String = ""
    @Persisted var pageNumber: String = ""
    
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
    
    convenience init(title: String, ownerId: String, coverUrl: String, author: String, descriptionOfBook: String, publisher: String, isbn: String, pageNumber: String, readingStatus: RealmReadStatus, startDate: Date, endDate: Date, rating: Int, currentReadingPage: Int, expectScore: Int, isDeleted: Bool) {
        self.init()
        self.title = title
        self.ownerId = ownerId
        self.coverUrl = coverUrl
        self.author = author
        self.descriptionOfBook = descriptionOfBook
        self.publisher = publisher
        self.isbn = isbn
        self.pageNumber = pageNumber
        
        self.readingStatus = readingStatus
        self.startDate = startDate
        self.endDate = endDate
        self.rating = rating
        self.currentReadingPage = currentReadingPage
        self.expectScore = expectScore
        self.isDeleted = isDeleted
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

    
    convenience init(date: Date, contents: String, PhotoURL: String) {
        self.init()
        self.date = date
        self.contents = contents
        self.photo = PhotoURL
    }
}

