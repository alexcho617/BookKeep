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
    
    func deleteBookFromRealm(handler: @escaping () -> Void){
        if let book = book.value{
            //TODO: 진짜로 지우진 말고 isDelete를 true로 변경처리해볼까? 이렇게 되면 CRUD 전반에서 PK랑 isDelete 둘다 확인해야한다.
            //Read할때 isDelete == false조건 추가해야함
//            BooksRepository.shared.deleteBook(isbn: book.isbn)
            BooksRepository.shared.markDelete(isbn: book.isbn)
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
