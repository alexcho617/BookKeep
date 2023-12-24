//
//  Provider.swift
//  BookKeep
//
//  Created by Alex Cho on 12/24/23.
//

import WidgetKit

struct Provider: TimelineProvider{
        
    typealias Entry = LatestBookEntryModel

    //TODO: define timeline
    
    func placeholder(in context: Context) -> LatestBookEntryModel {
        <#code#>
    }
    
    func getSnapshot(in context: Context, completion: @escaping (LatestBookEntryModel) -> Void) {
        <#code#>
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<LatestBookEntryModel>) -> Void) {
        <#code#>
    }
    
    
    
}
