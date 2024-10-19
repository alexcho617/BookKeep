//
//  WidgetLatestBook.swift
//  WidgetLatestBook
//
//  Created by Alex Cho on 12/23/23.
//

import WidgetKit
import SwiftUI


struct WidgetLatestBook: Widget {
    //unique widget identifier
    static let kind: String = "WidgetLatestBook"

    var body: some WidgetConfiguration { //3가지 컨피겨레이션이 있음
        //static 위젯
        StaticConfiguration(kind: WidgetLatestBook.kind, provider: LatestBookProvider()) { entry in
            if #available(iOS 17.0, *) {
                LatestBookEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget) //iOS17 modifier
            } else {
                LatestBookEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("최근 책")
        .description("최근에 읽은 책을 보여줍니다")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryInline, .accessoryCircular, .accessoryRectangular])
    }
}
