//
//  AladinSearch.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/29.
//

import Foundation

// MARK: - AladinSearch
struct AladinSearch: Hashable, Codable {
    let identifier = UUID().uuidString
    let version: String?
    let logo: String?
    let title: String?
    let link: String?
    let pubDate: String?
    let totalResults, startIndex, itemsPerPage: Int?
    let query: String?
    let searchCategoryID: Int?
    let searchCategoryName: String?
    let item: [Item]
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    static func == (lhs: AladinSearch, rhs: AladinSearch) -> Bool {
           return lhs.identifier == rhs.identifier
       }
    enum CodingKeys: String, CodingKey {
        case version, logo, title, link, pubDate, totalResults, startIndex, itemsPerPage, query
        case searchCategoryID = "searchCategoryId"
        case searchCategoryName, item
    }
}

// MARK: - Item
struct Item: Hashable,Codable {
    let identifier = UUID().uuidString
    let title: String
    let link: String
    let author, pubDate, description, isbn: String
    let isbn13: String
    let itemID, priceSales, priceStandard: Int
    let mallType, stockStatus: String
    let mileage: Int
    let cover: String
    let categoryID: Int
    let categoryName, publisher: String
    let salesPoint: Int
    let adult, fixedPrice: Bool
    let customerReviewRank: Int
    let subInfo: SubInfo?
    let seriesInfo: SeriesInfo?

    enum CodingKeys: String, CodingKey {
        case title, link, author, pubDate, description, isbn, isbn13
        case itemID = "itemId"
        case priceSales, priceStandard, mallType, stockStatus, mileage, cover
        case categoryID = "categoryId"
        case categoryName, publisher, salesPoint, adult, fixedPrice, customerReviewRank, subInfo, seriesInfo
    }
}

// MARK: - SeriesInfo
struct SeriesInfo: Hashable, Codable {
    let seriesID: Int?
    let seriesLink: String?
    let seriesName: String?

    enum CodingKeys: String, CodingKey {
        case seriesID = "seriesId"
        case seriesLink, seriesName
    }
}

// MARK: - SubInfo
struct SubInfo: Hashable, Codable {
    let subTitle: String?
    let originalTitle: String?
    let itemPage: Int?
}
