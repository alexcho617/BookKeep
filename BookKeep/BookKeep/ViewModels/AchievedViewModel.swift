//
//  AchievedViewModel.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/15.
//

import Foundation
import RealmSwift

class AchievedViewModel{
    
    var booksDoneReading: Observable<Results<RealmBook>>

    private var notificationTokens: [NotificationToken] = []
    init() {
        //다 읽은 책 들만 가져옴
        booksDoneReading = Observable(BooksRepository.shared.fetchBooksByStatus(.done))
        //구독 시킴
        observeRealmChanges(for: booksDoneReading)
    }

    //listen for changes of realm objects and update the observables
    private func observeRealmChanges(for observable: Observable<Results<RealmBook>>){
        let token = observable.value.observe { changes in
            switch changes {
            case .initial(let results):
                print("DEBUG: AchievedViewModel-observeRealmChanges: initialized")
                observable.value = results
            case .update(let results, deletions: _, insertions: _, modifications: _):
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
