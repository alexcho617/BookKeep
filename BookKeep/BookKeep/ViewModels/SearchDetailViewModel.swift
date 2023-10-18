//
//  SearchDetailViewModel.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/30.
//

import Foundation

class SearchDetailViewModel{
    var lookupResult: Observable<AladinSearch?> = Observable(nil)

    func lookUp(id: String, failHandler: @escaping () -> Void){
        NetworkManager.shared.requestConvertible(type: AladinSearch.self, api: .lookup(itemId: id)) { response in
            switch response {
            case .success(let success):
                self.lookupResult.value = success
            case .failure(let failure):
                dump(failure)
                failHandler()
            }
        }
    }
    
    deinit {
        print("SearchDetailViewModel deinit")
    }
}
