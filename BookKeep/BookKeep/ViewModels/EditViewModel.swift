//
//  EditViewModel.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/05.
//

import Foundation
import RealmSwift

class EditViewModel{
    let isbn: String
    let realm = Realm.safeInit()
    var book: RealmBook?
    
    init(isbn: String) {
        self.isbn = isbn
        book = realm?.object(ofType: RealmBook.self, forPrimaryKey: isbn)
    }
    var pageInput: Observable<String?> = Observable(nil)
  
    func validate() -> Bool{
        guard let number = Int(pageInput.value ?? "") else {return false}
        guard let book = book else {return false}
        if 0 <= number && number <= book.page {
            BooksRepository.shared.updateCurrentPage(isbn: isbn, to: number)
            return true
        }else {
            return false
        }
    }
}
