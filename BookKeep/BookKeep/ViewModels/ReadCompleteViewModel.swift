//
//  ReadCompleteViewModel.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/14.
//

import Foundation
import RealmSwift

class ReadCompleteViewModel{
    let isbn: String
    let realm = Realm.safeInit()
    var book: Observable<RealmBook?> = Observable(nil)
//    var book: RealmBook?
    var pageInput: Observable<String?> = Observable(nil)
    var readTimeInput: Observable<Double?> = Observable(nil)
    var startTimeInput: Observable<Date?> = Observable(Date())
    
    init(isbn: String) {
        self.isbn = isbn
        book.value = realm?.object(ofType: RealmBook.self, forPrimaryKey: isbn)
    }
    
    private func addReadSessionToRealm(session: ReadSession){
        let realm = Realm.safeInit()
        try! realm?.write {
            book.value?.readSessions.append(session)
        }
    }
    
    func addSession() -> Bool{
        guard let book = book.value else {
            print("No Book")
            return false
        }
        guard let startTime: Date = startTimeInput.value else {
            print("No start date")
            return false
        }
        
        guard let readTime = readTimeInput.value else {
            print("No read time")
            return false
        }
        
        guard let endPage = Int(pageInput.value ?? "") else {
            print("No Page")
            return false
        }
        
        if 0 <= endPage && endPage <= book.page {
            print("Create session")
            let session = ReadSession(startTime: startTime, endPage: endPage, duration: readTime)
            
            addReadSessionToRealm(session: session)
            BooksRepository.shared.updateCurrentPage(isbn: isbn, to: endPage)
            //TODO: Widget: Save Book Info to UserDefaults suite for widget
            //For Widget
            UserDefaults.groupShared.set(isbn, forKey: "ISBN")
            UserDefaults.groupShared.set(book.coverUrl, forKey: "CoverURL")
            UserDefaults.groupShared.set(book.title, forKey: "Title")
            UserDefaults.groupShared.set(book.author, forKey: "Author")
            return true
        }else {
            return false
        }
    }
}
