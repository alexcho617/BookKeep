//
//  LatestBookEntryView.swift
//  BookKeep
//
//  Created by Alex Cho on 12/24/23.
//

import SwiftUI

struct LatestBookEntryView: View {
    var entry: LatestBookProvider.Entry
    var body: some View {
        //TODO: Create view
        HStack{
            Image(uiImage: entry.coverImage).resizable()
//            AsyncImage(url: URL(string: UserDefaults.groupShared.string(forKey: "CoverURL") ?? entry.coverURL)) { image in
//                image.resizable()
//            } placeholder: {
//                ProgressView()
//            }
            .frame(width: 100, height: 150)
            VStack(alignment: .leading){
//                Text(entry.date, style: .time)
                Text(UserDefaults.groupShared.string(forKey: "Title") ?? "최근 제목 없음")
                    .font(.title3)
                Text(UserDefaults.groupShared.string(forKey: "Author") ?? "최근 지은이 없음")
            }
        }
    }
}
