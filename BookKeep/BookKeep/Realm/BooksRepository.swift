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
    case alreadyExist = "책이 이미 존재합니다"
}

class BooksRepository: Error, LocalizedError{
    static let shared = BooksRepository()
    let realm = Realm.safeInit()
    private init(){
    }
    
    func create(_ book: RealmBook) throws {
        //PK exists: Check if it was deleted book
        guard realm?.object(ofType: RealmBook.self, forPrimaryKey: book.isbn) == nil else {
            //Old record exists: then simply mark it's isDeleted to false and recover it.
            let existingBook = realm?.object(ofType: RealmBook.self, forPrimaryKey: book.isbn)
            if existingBook?.isDeleted == true{
                recoverBook(isbn: book.isbn)
            }else{
                throw RealmError.primaryKey
            }
         return
        }
        //PK doesnt exist:
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
    
    func updateCurrentPage(isbn: String, to newPage: Int){
        let book = realm!.object(ofType: RealmBook.self, forPrimaryKey: isbn)
        try! realm?.write {
            book?.currentReadingPage = newPage
        }
    }

    func recoverBook(isbn: String){
        let book = realm!.object(ofType: RealmBook.self, forPrimaryKey: isbn)
        try! realm?.write {
            book?.isDeleted = false
            book?.readingStatus = .toRead
        }
    }
    
    func fetchBooksByStatus(_ status: RealmReadStatus) -> Results<RealmBook>{
        return realm!.objects(RealmBook.self).where{
            return ($0.isDeleted == false) && ($0.readingStatus.rawValue == status.rawValue)
        }
    }
    
    //Fetch all except the ones marked as deleted
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
