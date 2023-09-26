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
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var ownerId: String
    @Persisted var coverUrl: String
    @Persisted var author: String
    @Persisted var descriptionOfBook: String
    @Persisted var publisher: String
    @Persisted var isbn: String
    @Persisted var pageNumber: String
    
    @Persisted var readingStatus: RealmReadStatus?
    @Persisted var startDate: Date?
    @Persisted var endDate: Date?
    @Persisted var rating: Int
    @Persisted var currentReadingPage: Int
    @Persisted var expectScore: Int
    @Persisted var isDeleted: Bool
    
    init(title: String, ownerId: String, coverUrl: String, author: String, descriptionOfBook: String, publisher: String, isbn: String, pageNumber: String, readingStatus: RealmReadStatus? = nil, startDate: Date? = nil, endDate: Date? = nil, rating: Int, currentReadingPage: Int, expectScore: Int, isDeleted: Bool) {
        //from API
        self.title = title
        self.ownerId = ownerId
        self.coverUrl = coverUrl
        self.author = author
        self.descriptionOfBook = descriptionOfBook
        self.publisher = publisher
        self.isbn = isbn
        self.pageNumber = pageNumber
        
        //app exclusive
        self.readingStatus = readingStatus
        self.startDate = startDate
        self.endDate = endDate
        self.rating = rating
        self.currentReadingPage = currentReadingPage
        self.expectScore = expectScore
        self.isDeleted = isDeleted
    }
}
