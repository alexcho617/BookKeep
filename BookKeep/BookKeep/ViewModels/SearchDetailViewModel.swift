//
//  SearchDetailViewModel.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/30.
//

import Foundation

class SearchDetailViewModel{
    var lookupResult: Observable<AladinSearch?> = Observable(nil)

    //TODO: 에러처리 -> 직접 추가하던가 해야할듯
    func lookUp(id: String){
        NetworkManager.shared.requestConvertible(type: AladinSearch.self, api: .lookup(itemId: id)) { response in
            switch response {
            case .success(let success):
                self.lookupResult.value = success
            case .failure(let failure):
                dump(failure)
            }
        }
    }
    
    deinit {
        print("SearchDetailViewModel deinit")
    }
}
