//
//  File.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/29.
//

import Foundation
import Alamofire

enum AladinRouter: URLRequestConvertible{
    
    case search(keyword: String)
    
    private var baseURL: URL{
        return URL(string: "https://www.aladin.co.kr/ttb/api/")!
    }
    
//https://www.aladin.co.kr/ttb/api/ItemSearch.aspx?ttbkey=ttbexist50051416002&version=20131101&QueryType=Title&start=1&SearchTarget=Book&output=js
    
    private var path: String{
        switch self {
        case .search:
            return "ItemSearch.aspx"
        }
    }
    
    var method: HTTPMethod{
        return .get
    }
    
    private var queries: [String: String]{
        switch self {
        case .search(let keyword):
            return ["ttbkey": Key.aladin,
                    "Query": keyword,
                    "version": "20131101",
                    "SearchTarget": "Book",
                    "QueryType": "Title",
                    "start": "1",
                    "Cover": "Big"
            ]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(queries, into: request)
        //TODO: URL은 정상, Decoding Error 발생
        print("DEBUG:",request.url)
        return request
    }
    
}
