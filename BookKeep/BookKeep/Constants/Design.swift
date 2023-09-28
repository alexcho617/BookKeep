//
//  DesignSystem.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/25.
//

import UIKit
enum Design{
    static let paddingDefault: CGFloat = 8.0
    
    static let colorPrimaryBackground = UIColor(named: "PrimaryBackground")
    static let colorSecondaryBackground = UIColor(named: "SecondaryBackground")

    static let colorPrimaryAccent = UIColor(named: "PrimaryAccent")
    static let colorSecondaryAccent = UIColor(named: "SecondaryAccent")
    
    static let colorTextTitle = colorSecondaryAccent
    static let colorTextSubTitle = UIColor.systemGray4
    
    static let fontDefault: UIFont = .systemFont(ofSize: 16, weight: .medium)
    static let fontTitle: UIFont = .systemFont(ofSize: 28, weight: .bold)
    static let fontSubTitle: UIFont = .systemFont(ofSize: 24, weight: .semibold)
    
    static let debugPink = UIColor.systemPink.withAlphaComponent(0.5)
    static let debugBlue = UIColor.systemBlue.withAlphaComponent(0.5)
}
