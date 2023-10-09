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

    var objectNotificationToken: NotificationToken?
    
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
                //TODO: snapshot.reloadsection으로 개선 가능
                self.delegate?.reloadCollectionView()
            case .error(let error):
                print("\(error)")
            case .deleted:
                print("object deleted")
            }
        }        
    }
    
    func addMemo(date: Date?, contents: String?, handler: @escaping () -> Void){
//        print("DetailViewModel-",#function, date, contents)
        guard let date = date, let contents = contents else {return}
        guard contents != "" else {return}
        
        //add to realm
        let newMemo = Memo(date: date, contents: contents, photo: "")
        let realm = Realm.safeInit()
        try! realm?.write {
            book.value?.memos.append(newMemo)
        }
        handler()
    }
    
    func updateMemo(memo: Memo, date: Date?, contents: String?, handler: @escaping () -> Void){
//        print("DetailViewModel-",#function, date, contents)
        guard let date = date, let contents = contents else {return}
        guard contents != "" else {return}
        
        //updatenrealm
        let realm = Realm.safeInit()
        let memo = realm?.object(ofType: Memo.self, forPrimaryKey: memo._id)
        try! realm?.write {
            memo?.contents = contents
            memo?.date = date
        }
        handler()
    }
    
    func deleteMemo(_ memo: Memo){
        let realm = Realm.safeInit()
        try! realm?.write {
            realm?.delete(memo)
        }
    }
    
    
    
    
    func deleteBookFromRealm(permanently: Bool = false, handler: @escaping () -> Void){
        if let book = book.value{
            if permanently == true{
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
