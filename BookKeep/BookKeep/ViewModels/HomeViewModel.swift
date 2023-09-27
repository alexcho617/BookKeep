//
//  HomeViewModel.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/25.
//

import Foundation
class HomeViewModel{
    let booksReading = Observable(MockData.booksReading())
    let bookstoRead = Observable(MockData.booksToRead())
    
    init() {
        
    }
}
