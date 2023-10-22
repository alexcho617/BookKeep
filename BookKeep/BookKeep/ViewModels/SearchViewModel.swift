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
    var currentPage: Int = 1
    
    func searchBook(query: String?, handler:@escaping ()->Void){
        
        // Reset currentPage to 1 when a new search is initiated
        //TODO: Query 할 때 페이지 "start": 를 늘려줘야함
        guard let query = query else {return}
        if searchResult.value == nil{
            currentPage = 1
        }
        NetworkManager.shared.requestConvertible(type: AladinSearch.self, api: .search(keyword: query, page: currentPage)) { response in
            print("VM currentPage:",self.currentPage)
            switch response {
            case .success(let success):
                if self.searchResult.value == nil{
                    self.searchResult.value = success
                }else{
                    self.searchResult.value?.item.append(contentsOf: success.item)
                }
                self.currentPage += 1
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
