//
//  SearchDetailViewModel.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/30.
//

import Foundation

class SearchDetailViewModel{
    var lookupResult: Observable<AladinSearch?> = Observable(nil)

    //TODO: 에러처리 -> aladin에서 제공해주지 않기 때문에 직접에러타입을 만들어야함
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
