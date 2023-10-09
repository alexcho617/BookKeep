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
    weak var delegate: DiffableDataSourceDelegate? //section 이동

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
                //여기서 리로드 호출 해버릴까
                self.delegate?.reloadCollectionView()

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
    func startReading(){
        guard let book = book.value else {return}
//        book.readingStatus = .reading 어차피 렘에서 바꾸면 다시 가져옴
        BooksRepository.shared.updateBookReadingStatus(isbn: book.isbn, to: .reading)
        delegate?.moveSection(itemToMove: book, from: .homeToRead, to: .homeReading)
    }
    
    deinit{
        objectNotificationToken?.invalidate()
    }
    
}
