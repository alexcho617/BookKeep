//
//  AchievedViewModel.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/15.
//

import Foundation
import RealmSwift

class AchievedViewModel{
    
    var books: Observable<Results<RealmBook>>

    private var notificationTokens: [NotificationToken] = []
    init() {
        //책 전체 불러옴
        books = Observable(BooksRepository.shared.fetchAllBooks())
        //구독 시킴
        observeRealmChanges(for: books)
    }

    //listen for changes of realm objects and update the observables
    private func observeRealmChanges(for observable: Observable<Results<RealmBook>>){
        let token = observable.value.observe { changes in
            switch changes {
            case .initial(let results):
                print("DEBUG: AchievedViewModel-observeRealmChanges: initialized")
                observable.value = results
            case .update(let results, deletions: _, insertions: _, modifications: _):
                //reassign observalbe.value and reflect in snapshot
                print("DEBUG: AchievedViewModel-observeRealmChanges: change detected")
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
