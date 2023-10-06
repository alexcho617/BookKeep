//
//  DetailViewModel.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/02.
//

import Foundation
import RealmSwift

class DetailViewModel{
    var isbn: String?
    var book: Observable<RealmBook?> = Observable(nil)
    //TODO: Memos
    var objectNotificationToken: NotificationToken?
    let numberOfRows = 4
    
    
    init(isbn: String){
        fetchBookFromRealm(isbn: isbn)
        guard let book = book.value else {return}
        observeRealmChanges(for: book)

        
    }
    
    func fetchBookFromRealm(isbn: String) {
        do {
            try book.value = BooksRepository.shared.fetchBookByPK(isbn: isbn)
        } catch {
            print(error)
        }
    }
    
    //listen for changes of realm objects and update the observables
    private func observeRealmChanges(for observable: RealmBook){
        objectNotificationToken = observable.observe { changes in
            switch changes {
            case .change(let object, _):
                let pk = object.value(forKey: "isbn")
                let realm = Realm.safeInit()
                //다시 넣어줌으로써 View의 바인드 호출
                self.book.value = realm?.object(ofType: RealmBook.self, forPrimaryKey: pk)
            case .error(let error):
                print("\(error)")
            case .deleted:
                print("object deleted")
            }
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
    
    deinit{
        objectNotificationToken?.invalidate()
    }
    
}
