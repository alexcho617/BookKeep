//
//  HomeViewModel.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/25.
//

import Foundation
import RealmSwift
final class HomeViewModel{
    var books: Observable<Results<RealmBook>>

    private var notificationTokens: [NotificationToken] = []
    init() {
        books = Observable(BooksRepository.shared.fetchAllBooks())
        observeRealmChanges(for: books)
        
    }
    
    //listen for changes of realm objects and update the observables
    private func observeRealmChanges(for observable: Observable<Results<RealmBook>>){
        let token = observable.value.observe { changes in
            switch changes {
            case .initial(let results):
                observable.value = results
            case .update(let results, deletions: _, insertions: _, modifications: _):
                observable.value = results
            case .error(let error):
                dump(error)
                dump(RealmError.nonExist)
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
