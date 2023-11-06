//
//  NetworkManager.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/29.
//

import Foundation
import Alamofire

class NetworkManager{
    static let shared = NetworkManager()
    private init() {}
    
    func requestConvertible<T: Decodable>(type: T.Type, api: AladinRouter, completion: @escaping (Result<T, AFError>) -> Void){
        AF.request(api).responseDecodable(of: T.self) { response in
            switch response.result{
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
