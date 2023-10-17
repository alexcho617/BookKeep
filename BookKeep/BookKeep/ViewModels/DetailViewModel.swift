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
    weak var homeDelegate: DiffableDataSourceDelegate? // HomeVC Delegate
    weak var achievedDelegate: AchievedDelegate? //AchievedVC Delegate
    private let booksRepository: BooksRepository
    var objectNotificationToken: NotificationToken?
    private let realm = Realm.safeInit()
    
    init(isbn: String, booksRepository: BooksRepository = BooksRepository.shared){
        self.booksRepository = booksRepository
        fetchBookFromRealm(isbn: isbn)
        guard let book = book.value else {return}
        observeRealmChanges(for: book)
        
        
    }
    
    func fetchBookFromRealm(isbn: String) {
        do {
            try book.value = booksRepository.fetchBookByPK(isbn: isbn)
        } catch {
            print(error)
        }
    }
    
    //listen for changes of realm objects and update the observables
    private func observeRealmChanges(for observable: RealmBook){
        objectNotificationToken = observable.observe { changes in
            print("DEBUG: DetailViewModel-",#function)
            switch changes {
            case .change(let object, _):
                let pk = object.value(forKey: "isbn")
//                let realm = Realm.safeInit()
                //다시 넣어줌으로써 View의 바인드 호출
                self.book.value = self.realm?.object(ofType: RealmBook.self, forPrimaryKey: pk)
                //TODO: snapshot.reloadsection으로 개선 가능
                //업적화면에서 온 경우 필요없음: readingStatus로 분기처리?
                if self.homeDelegate != nil{
                    self.homeDelegate?.reloadCollectionView()
                }
                if self.achievedDelegate != nil{
                    self.achievedDelegate?.reloadCollectionView()
                }
                
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
//        let realm = Realm.safeInit()
        
        do {
//            let realm = Realm.safeInit()
            try realm?.write {
                book.value?.memos.append(newMemo)
            }
        } catch {
            print("Realm Error: \(error)")
        }
        
        
        handler()
    }
    
    func updateMemo(memo: Memo, date: Date?, contents: String?) -> Bool{
        //        print("DetailViewModel-",#function, date, contents)
        guard let date = date, let contents = contents else {return false}
        guard contents != "" else {return false}
        
        //변경 없으면 그냥 리턴
        guard memo.contents != contents || memo.date != date else {
            print("DEBUG: No Memo Change")
            return false
        }
        
        //update realm observeRealmChanges 호출안됨
//        let realm = Realm.safeInit()
        let memo = realm?.object(ofType: Memo.self, forPrimaryKey: memo._id)
        
        do {
//            let realm = Realm.safeInit()
            try realm?.write {
                memo?.contents = contents
                memo?.date = date
            }
        } catch {
            print("Realm Error: \(error)")
        }
        
        self.homeDelegate?.reloadCollectionView()
        return true
    }
    
    func deleteMemo(_ memo: Memo){
        do {
            //이거 계속 해야하나? 한번만 하면 안됨?
//            let realm = Realm.safeInit()
            try realm?.write {
                realm?.delete(memo)
                
            }
        } catch {
            print("Realm Error: \(error)")
        }
        
        
    }
    
    
    
    
    func deleteBookFromRealm(permanently: Bool = false, handler: @escaping () -> Void){
        if let book = book.value{
            if permanently == true{
                booksRepository.deleteBook(isbn: book.isbn)
            }else{
                booksRepository.markDelete(isbn: book.isbn)
            }
            handler()
        }
        
    }
    
    //view에도 반영
    func startReading(){
        guard let book = book.value else {return}
        //        book.readingStatus = .reading 어차피 렘에서 바꾸면 다시 가져옴
        booksRepository.updateBookReadingStatus(isbn: book.isbn, to: .reading)
        homeDelegate?.moveSection(itemToMove: book, from: .homeToRead, to: .homeReading)
    }
    
    deinit{
        objectNotificationToken?.invalidate()
    }
    
}
