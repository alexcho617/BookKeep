//
//  BooksRepository.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/26.
//

import Foundation
import RealmSwift

class BooksRepository {
    let shared = BooksRepository()
    let realm = Realm.safeInit()
    
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
