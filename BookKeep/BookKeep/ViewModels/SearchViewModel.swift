//
//  SearchViewModel.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/29.
//

import Foundation
class SearchViewModel{
    
    var searchResult: Observable<AladinSearch?> = Observable(nil)
    
    func searchBook(query: String?, handler: (()->Void)?){
        guard let query = query else {return}
        NetworkManager.shared.requestConvertible(type: AladinSearch.self, api: .search(keyword: query)) { response in
            switch response {
            case .success(let success):
                self.searchResult.value = success
                
            case .failure(let failure):
                dump(failure)
            }
        }
        
        handler?()
    }
    
    deinit {
        print("SearchViewModel deinit")
    }
}
