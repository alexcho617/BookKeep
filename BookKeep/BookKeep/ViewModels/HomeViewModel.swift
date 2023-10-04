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
    var books: Observable<Results<RealmBook>>

    private var notificationTokens: [NotificationToken] = []
    init() {
        realm = BooksRepository.shared.realm
        books = Observable(BooksRepository.shared.fetchAllBooks())
        observeRealmChanges(for: books)
    }
    
    //listen for changes of realm objects and update the observables
    private func observeRealmChanges(for observable: Observable<Results<RealmBook>>){
        let token = observable.value.observe { changes in
            switch changes {
            case .initial(let results):
                print("DEBUG: HomeViewModel-observeRealmChanges: initialized")
                observable.value = results
            case .update(let results, deletions: _, insertions: _, modifications: _):
                //reassign observalbe.value and reflect in snapshot
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
