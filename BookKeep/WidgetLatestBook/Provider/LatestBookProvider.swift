//
//  Provider.swift
//  BookKeep
//
//  Created by Alex Cho on 12/24/23.
//

import WidgetKit
import SwiftUI

struct LatestBookProvider: TimelineProvider{
        
    typealias Entry = LatestBookEntryModel

    //TODO: define timeline
    
    func placeholder(in context: Context) -> LatestBookEntryModel {
        LatestBookEntryModel(date: Date(), isbn: "isbnSample", bookTitle: "sampleTitle", author: "sampleAuthor", coverURL: "sampleURL", coverImage: UIImage(systemName: "book")!)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (LatestBookEntryModel) -> Void) {
        let entry = LatestBookEntryModel(date: Date(), isbn: "isbnSample", bookTitle: "sampleTitle", author: "sampleAuthor", coverURL: "sampleURL", coverImage: UIImage(systemName: "book")!)
        
        completion(entry)

    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<LatestBookEntryModel>) -> Void) {
        var entries: [LatestBookEntryModel] = []
        var coverImage: UIImage!
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 { //미래 시간에 대한 뷰를 그릴 수 있도록 타임라인에 추가함
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: URL(string: UserDefaults.groupShared.string(forKey: "CoverURL") ?? "")!) {
                            if let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    coverImage = image
                                    print("Widget CoverImage",coverImage.size)
                                    let entry = LatestBookEntryModel(
                                        date: entryDate,
                                        isbn: UserDefaults.groupShared.string(forKey: "ISBN") ?? "isbnSample",
                                        bookTitle: UserDefaults.groupShared.string(forKey: "Title") ?? "titleSample",
                                        author: UserDefaults.groupShared.string(forKey: "Author") ?? "authorSample",
                                        coverURL: UserDefaults.groupShared.string(forKey: "CoverURL") ?? "urlSample",
                                        coverImage: coverImage
                                    )
                                    entries.append(entry)
                                }
                            }
                        }
                    }
        }
        
        //마지막 엔트리가 지나면 위젯킷이 새로운 다임라인을 요청할수 있도록 설정한다 (.atEnd)
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline) //미래에 시점이 계산되어서 보여지게 됨
    }
    
    
    
}
