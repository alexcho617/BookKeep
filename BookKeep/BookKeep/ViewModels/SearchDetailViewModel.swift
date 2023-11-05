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
            case .success(var success):
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

//TODO: String이 immutable 이기 때문에 바로 AladinSearch model에 적용 불가능.
extension String {
    func decodeHTMLEntities() -> String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return attributedString.string
        }
        return self
    }
}
