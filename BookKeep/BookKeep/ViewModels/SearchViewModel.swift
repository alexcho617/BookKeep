//
//  SearchViewModel.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/29.
//

import Foundation
class SearchViewModel{
    
    let query: Observable<String?> = Observable(nil)
    var list: Observable<[RealmBook]> = Observable([])
    
    
    func searchBook(query: String?){
        guard let query = query else {return}
        NetworkManager.shared.requestConvertible(type: AladinSearch.self, api: .search(keyword: query)) { response in
            switch response {
            case .success(let success):
                print("DEBUG: Completion SUCCESS")
                dump(success)
            case .failure(let failure):
                print("DEBUG: Completion FAILURE")
                dump(failure)
            }
        }
    }
    
    deinit {
        print("SearchViewModel deinit")
    }
}
