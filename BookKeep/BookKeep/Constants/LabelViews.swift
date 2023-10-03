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
