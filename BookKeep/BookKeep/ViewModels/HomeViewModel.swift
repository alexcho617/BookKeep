//
//  HomeViewModel.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/25.
//

import Foundation
final class HomeViewModel{
    var booksReading = Observable([RealmBook]())
    var booksToRead = Observable([RealmBook]())
    
    init() {
        booksReading.value = MockData.booksReading()
        booksToRead.value = MockData.booksToRead()
    }
}
