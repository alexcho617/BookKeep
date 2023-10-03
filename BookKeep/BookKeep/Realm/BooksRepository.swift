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
        // Open a thread-safe transaction
        try! realm?.write {
            // Update some properties on the instance.
            // These changes are saved to the realm
            book?.readingStatus = status
        }
    }
    
    func fetchBooksToRead() -> Results<RealmBook> {
        return realm!.objects(RealmBook.self).where{
            return $0.readingStatus.rawValue == RealmReadStatus.toRead.rawValue
        }
    }
    
    func fetchBooksReading() -> Results<RealmBook> {
        return realm!.objects(RealmBook.self).where{
            return $0.readingStatus.rawValue == RealmReadStatus.reading.rawValue
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
