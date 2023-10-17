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
    private let booksRepository: BooksRepository
    private let realm = Realm.safeInit()
    var objectNotificationToken: NotificationToken?

    weak var homeDelegate: DiffableDataSourceDelegate? // HomeVC Delegate
    weak var achievedDelegate: AchievedDelegate? //AchievedVC Delegate
    
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
    
    private func observeRealmChanges(for observable: RealmBook){
        objectNotificationToken = observable.observe { changes in
            print("DEBUG: DetailViewModel-",#function)
            switch changes {
            case .change(let object, _):
                let pk = object.value(forKey: "isbn")
                //reassign and invoke view's binding
                self.book.value = self.realm?.object(ofType: RealmBook.self, forPrimaryKey: pk)
                
                //delegate에 따라 분기 처리
                if self.homeDelegate != nil{
                    self.homeDelegate?.reloadCollectionView()
                }
                else if self.achievedDelegate != nil{
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
        
        do {
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
        
        //return if no change
        guard memo.contents != contents || memo.date != date else {
            print("DEBUG: No Memo Change")
            return false
        }
        
        let memo = realm?.object(ofType: Memo.self, forPrimaryKey: memo._id)
        do {
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
    
    //다시 읽는 경우 분기처리
    func startReading(isAgain: Bool, handler: (() -> Void)?){
        guard let book = book.value else {return}
        if isAgain{
            booksRepository.updateBookReadingStatus(isbn: book.isbn, to: .toRead)
            booksRepository.updateCurrentPage(isbn: book.isbn, to: 0)
            handler?()
        }else{
            booksRepository.updateBookReadingStatus(isbn: book.isbn, to: .reading)
            homeDelegate?.moveSection(itemToMove: book, from: .homeToRead, to: .homeReading)
        }
    }
    
    deinit{
        objectNotificationToken?.invalidate()
    }
    
}
