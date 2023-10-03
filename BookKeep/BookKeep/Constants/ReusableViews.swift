//
//  LabelViews.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/02.
//

import UIKit

//MARK: Labels
enum LabelViews{
    static var authorLabel = {
        let view = UILabel()
        view.text = "저자"
        view.font = Design.fontAccentDefault
        view.textColor = Design.colorTextSubTitle
        return view
    }()
    static var introductionLabel = {
        let view = UILabel()
        view.text = "책 소개"
        view.font = Design.fontAccentDefault
        view.textColor = Design.colorTextSubTitle
        return view
    }()
    static var publisherLabel = {
        let view = UILabel()
        view.text = "출판사"
        view.font = Design.fontAccentDefault
        view.textColor = Design.colorTextSubTitle
        return view
    }()
    static var isbnLabel = {
        let view = UILabel()
        view.text = "ISBN"
        view.font = Design.fontAccentDefault
        view.textColor = Design.colorTextSubTitle
        return view
    }()
    static var pageLabel = {
        let view = UILabel()
        view.text = "페이지"
        view.font = Design.fontAccentDefault
        view.textColor = Design.colorTextSubTitle
        return view
    }()
}

enum ButtonViews {
    static var readButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "timer"), for: .normal)
        button.backgroundColor = Design.colorPrimaryAccent
        button.tintColor = Design.colorSecondaryAccent
        button.layer.cornerRadius = Design.paddingDefault
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    static var memoButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "note.text.badge.plus"), for: .normal)
        button.backgroundColor = Design.colorPrimaryAccent
        button.tintColor = Design.colorSecondaryAccent
        button.layer.cornerRadius = Design.paddingDefault
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowOpacity = 0.5
        return button
    }()
}
