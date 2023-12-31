//
//  File.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/29.
//

import Foundation
import Alamofire

enum AladinRouter: URLRequestConvertible{
    
    case search(keyword: String, page: Int)
    case lookup(itemId: String)
    private var baseURL: URL{
        return URL(string: "https://www.aladin.co.kr/ttb/api/")!
    }
    
    private var path: String{
        switch self {
        case .search:
            return "ItemSearch.aspx"
        case .lookup:
            return "ItemLookUp.aspx"
        }
    }
    
    var method: HTTPMethod{
        return .get
    }
    
    
    private var queries: [String: String]{
        switch self {
        case .search(let keyword, let page):
            return ["ttbkey": Key.aladin,
                    "Query": keyword,
                    "version": "20131101",
                    "SearchTarget": "Book",
                    "QueryType": "Title",
                    "MaxResults": "\(Literal.apiMaxResults)",
                    "start": String(page),
                    "Cover": "Big",
                    "Output": "JS"
            ]
        case .lookup(let itemId):
            return ["ttbkey": Key.aladin,
                    "ItemId": itemId,
                    "version": "20131101",
                    "Cover": "Big",
                    "Output": "JS"
            ]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let timeoutInterval: TimeInterval = 5
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request.timeoutInterval = timeoutInterval
        request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(queries, into: request)
        return request
    }
    
}
