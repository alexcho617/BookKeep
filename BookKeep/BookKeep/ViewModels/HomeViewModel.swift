//
//  HomeViewModel.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/25.
//

import Foundation
import RealmSwift
final class HomeViewModel{
    let realm: Realm?
    var booksReading: Observable<Results<RealmBook>>
    var booksToRead: Observable<Results<RealmBook>>
    private var notificationTokens: [NotificationToken] = []
    init() {
        realm = BooksRepository.shared.realm
        
        booksReading = Observable(BooksRepository.shared.fetchBooksReading())
        booksToRead = Observable(BooksRepository.shared.fetchBooksToRead())
        
        observeRealmChanges(for: booksToRead)
        observeRealmChanges(for: booksReading)
    }
    
    //listen for changes of realm objects and update the observables
    private func observeRealmChanges(for observable: Observable<Results<RealmBook>>){
        let token = observable.value.observe { changes in
            switch changes {
            case .initial(let results):
                print("DEBUG: HomeViewModel-observeRealmChanges: initialized")
                observable.value = results
            case .update(let results, _, _, _):
                print("DEBUG: HomeViewModel-observeRealmChanges: change detected")
                observable.value = results
            case .error(let error):
                print(error, RealmError.nonExist)
            }
        }
        notificationTokens.append(token)
    }
    
    deinit{
        for token in notificationTokens {
            token.invalidate()
        }
    }
}
