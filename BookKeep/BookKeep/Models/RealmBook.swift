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

enum RealmBookOwnershipStatus: String, PersistableEnum, Hashable {
    case owned
    case borrowed
    case wishList
}

final class RealmBook: Object {
    //from API
    @Persisted(primaryKey: true) var isbn: String
    @Persisted var title: String = ""
    @Persisted var coverUrl: String = ""
    @Persisted var author: String = ""
    @Persisted var descriptionOfBook: String = ""
    @Persisted var publisher: String = ""
    @Persisted var page: Int = 0
    @Persisted var itemLink: String = "" // Link to the item on the Aladin website
    @Persisted var priceSales: Int = 0 // Sales price of the book
    @Persisted var priceStandard: Int = 0 // Standard price of the book
    @Persisted var categoryId: Int = 0 // Category ID of the book
    @Persisted var categoryName: String = "" // Category name of the book
    @Persisted var customerReviewRank: Int = 0 // Customer review rank of the book
    @Persisted var adult: Bool = false // Indicates if the book is for adults
   
    
    //app exclusive
    @Persisted var readingStatus: RealmReadStatus = .toRead
    @Persisted var ownershipStatus: RealmBookOwnershipStatus = .owned
    @Persisted var startDate: Date = .now
    @Persisted var endDate: Date = .now
    @Persisted var rating: Int = 0
    @Persisted var currentReadingPage: Int = 0
    @Persisted var expectScore: Int = 0
    @Persisted var isDeleted: Bool = false
    @Persisted var readIteration: Int = 0
    @Persisted var borrowedTo: String? = nil // Stores the name of the person who borrowed the book (nil if not borrowed)
    
    //Relationship Properties
    @Persisted var readSessions: List<ReadSession>
    @Persisted var memos: List<Memo>
    
    convenience init(isbn: String, title: String, coverUrl: String, author: String, descriptionOfBook: String, publisher: String, page: Int, readItration: Int, itemLink: String, priceSales: Int, priceStandard: Int, categoryId: Int, categoryName: String, customerReviewRank: Int, adult: Bool) {
        self.init()
        self.isbn = isbn
        self.title = title
        self.coverUrl = coverUrl
        self.author = author
        self.descriptionOfBook = descriptionOfBook
        self.publisher = publisher
        self.page = page
        self.readIteration = readItration
        self.itemLink = itemLink
        self.priceSales = priceSales
        self.priceStandard = priceStandard
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.customerReviewRank = customerReviewRank
        self.adult = adult
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
