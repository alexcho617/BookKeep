//
//  SearchViewModel.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/29.
//

import Foundation
class SearchViewModel{
    var errorHandler: (() -> Void)?

    var searchResult: Observable<AladinSearch?> = Observable(nil)
    
    func searchBook(query: String?, handler:@escaping ()->Void){
        searchResult.value = nil
        guard let query = query else {return}
        NetworkManager.shared.requestConvertible(type: AladinSearch.self, api: .search(keyword: query)) { response in
            switch response {
            case .success(let success):
                self.searchResult.value = success
                handler()
            case .failure(let failure):
                dump(failure)
                self.errorHandler?()
                return
            }
        }
    }
    
    deinit {
        print("SearchViewModel deinit")
    }
}
