//
//  BooksRepository.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/26.
//

import Foundation
import RealmSwift

enum RealmError: String, Error, LocalizedError{
    case primaryKey = "PK 에러가 났습니다"
    case nonExist = "데이터가 없습니다"
}
class BooksRepository: Error, LocalizedError{
    static let shared = BooksRepository()
    let realm = Realm.safeInit()
    private init(){
    }
    
    //이미 추가한 기록이 있으나 isDeleted로 표기 된 도서 핸들함. -> 근데 이걸 왜 해야하지? ViewUpdate가 조금 더 쉬워지긴 하고 안지우면 나중에 쓸 일이 있을것 같긴 한데..
    func create(_ book: RealmBook) throws {
        //check pk existence
        guard realm?.object(ofType: RealmBook.self, forPrimaryKey: book.isbn) == nil else {
            throw RealmError.primaryKey
        }
        do {
            try realm?.write{
                realm?.add(book)
            }
        } catch {
            throw RealmError.primaryKey
        }
        
    }
    
    func deleteBook(isbn: String){
        guard let target = realm?.object(ofType: RealmBook.self, forPrimaryKey: isbn) else {return}
        
        try! realm?.write {
            realm?.delete(target)
        }
    }
    func markDelete(isbn: String){
        guard let book = realm?.object(ofType: RealmBook.self, forPrimaryKey: isbn) else {return}
        
        try! realm?.write {
            book.isDeleted = true
        }
    }
    
    func fetchBookByPK(isbn: String) throws -> RealmBook? {
        do {
            guard let result = realm!.object(ofType: RealmBook.self, forPrimaryKey: isbn) else{
                throw RealmError.nonExist
            }
            return result
        } catch {
            throw RealmError.nonExist
        }
    }
    
    func updateBookReadingStatus(isbn: String, to status: RealmReadStatus) {
        let book = realm!.object(ofType: RealmBook.self, forPrimaryKey: isbn)
        try! realm?.write {
            book?.readingStatus = status
        }
    }
    
    func fetchBooksByStatus(_ status: RealmReadStatus) -> Results<RealmBook>{
        return realm!.objects(RealmBook.self).where{
            return ($0.isDeleted == false) && ($0.readingStatus.rawValue == status.rawValue)
        }
    }
    
    func fetchAllBooks() -> Results<RealmBook>{
        return realm!.objects(RealmBook.self).where {
            $0.isDeleted == false
        }
    }
    func realmURL(){
        print(realm?.configuration.fileURL ?? "")
    }
    
}

extension Realm {
    static func safeInit() -> Realm? {
        do {
            let realm = try Realm()
            return realm
        }
        catch {
            print("Realm Safe Init Failed")
        }
        return nil
    }
    
}
