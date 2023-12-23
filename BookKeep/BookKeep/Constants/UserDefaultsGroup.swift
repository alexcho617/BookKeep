//
//  UserDefaultsGroup.swift
//  BookKeep
//
//  Created by Alex Cho on 12/23/23.
//

import Foundation
extension UserDefaults{
    static var groupShared: UserDefaults{
        let appGroupID = "group.com.alexcho617.BookKeep"
        return UserDefaults(suiteName: appGroupID)!
    }
}
