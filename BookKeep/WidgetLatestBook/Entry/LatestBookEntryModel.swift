//
//  LatestBookEntryModel.swift
//  BookKeep
//
//  Created by Alex Cho on 12/24/23.
//

import WidgetKit
import SwiftUI
struct LatestBookEntryModel: TimelineEntry {
    var date: Date
    //TODO: add model data, Book info, image url etc..
    var isbn: String
    var bookTitle: String
    var author: String
    var coverURL: String
    var coverImage: UIImage
    
}
