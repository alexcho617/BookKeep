//
//  Enums.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/30.
//

import Foundation

enum TransitionStyle{
    case present
    case presentWithNavigation
    case presentWithFullNavigation
    case push
}

//Diffable: 섹션 종류
enum SectionLayoutKind: Int, CaseIterable{
    case homeReading
    case homeToRead
    var columnCount: Int{
        switch self{
        case .homeReading:
            return 1
        case .homeToRead:
            return 2
        }
    }
}

//Diffable: 헤더 종류
enum SectionSupplementaryKind: String{
    case readingHeader
    case toReadHeader
}

enum UserDefaultsKey: String{
    case LastElapsedTime
    case LastReadingState
    case LastISBN //이건 아직 안 쓸 수 있음
}
