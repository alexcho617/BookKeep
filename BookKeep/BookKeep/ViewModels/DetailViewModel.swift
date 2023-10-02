//
//  DetailViewModel.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/02.
//

import Foundation
class DetailViewModel{
    var book: Observable<RealmBook?> = Observable(nil)

    func fetchBookFromRealm(isbn: String) throws {
        do {
            try book.value = BooksRepository.shared.fetchBookByPK(isbn: isbn)
        } catch let error {
            throw error
        }
        
        
    }
    
    deinit {
        print("DetailViewModel deinit")
    }
}
