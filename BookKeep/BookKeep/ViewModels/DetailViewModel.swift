//
//  DetailViewModel.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/02.
//

import Foundation
import RealmSwift

class DetailViewModel{
    var book: Observable<RealmBook?> = Observable(nil)

    func fetchBookFromRealm(isbn: String) throws {
        do {
            try book.value = BooksRepository.shared.fetchBookByPK(isbn: isbn) ?? RealmBook()
        } catch let error {
            throw error
        }
    }
    
    func deleteBookFromRealm(permanantly: Bool = false, handler: @escaping () -> Void){
        if let book = book.value{
            if permanantly == true{
                BooksRepository.shared.deleteBook(isbn: book.isbn)
            }else{
                BooksRepository.shared.markDelete(isbn: book.isbn)
            }
            handler()
        }
        
    }
    
    
    
    //view에도 반영
    func startReading(handler: @escaping () -> Void){
        guard let book = book.value else {return}
        BooksRepository.shared.updateBookReadingStatus(isbn: book.isbn, to: .reading)
        handler()
    }
    
    deinit {
        
    }
}
