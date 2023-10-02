//
//  HomeViewModel.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/25.
//

import Foundation
import RealmSwift
final class HomeViewModel{
    var booksReading: Observable<Results<RealmBook>>
    var booksToRead: Observable<Results<RealmBook>>
    
    init() {
        booksReading = Observable(BooksRepository.shared.fetchBooksReading())
        booksToRead = Observable(BooksRepository.shared.fetchBooksToRead())

    }
}
