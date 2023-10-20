//
//  LabelViews.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/02.
//

import UIKit

//MARK: Label
struct LabelViews{
    var authorLabel = {
        let view = UILabel()
        view.text = "저자"
        view.font = Design.fontAccentDefault
        view.textColor = Design.colorTextSubTitle
        return view
    }()
    var introductionLabel = {
        let view = UILabel()
        view.text = "책 소개"
        view.font = Design.fontAccentDefault
        view.textColor = Design.colorTextSubTitle
        return view
    }()
    var publisherLabel = {
        let view = UILabel()
        view.text = "출판사"
        view.font = Design.fontAccentDefault
        view.textColor = Design.colorTextSubTitle
        return view
    }()
    var isbnLabel = {
        let view = UILabel()
        view.text = "ISBN"
        view.font = Design.fontAccentDefault
        view.textColor = Design.colorTextSubTitle
        return view
    }()
    var pageLabel = {
        let view = UILabel()
        view.text = "페이지"
        view.font = Design.fontAccentDefault
        view.textColor = Design.colorTextSubTitle
        return view
    }()
}


struct DetailViewComponents{
    let bookTitle = {
        let view = UILabel()
        view.textColor = Design.colorTextSubTitle
        view.font = Design.fontSubTitle
        view.text = "제목"
        view.numberOfLines = 0
        return view
    }()
    
    let coverImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.borderColor = Design.colorPrimaryAccent?.cgColor
        view.layer.borderWidth = 2
        
        view.layer.cornerRadius = Design.paddingDefault
        view.clipsToBounds = true
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.layer.shadowOpacity = 0.5
        return view
    }()
    
    let author = {
        let view = UILabel()
        view.text = "저자"
        view.font = Design.fontDefault
        view.textColor = Design.colorTextDefault
        view.numberOfLines = 0
        return view
    }()
    
    let totalReadTime = {
        let view = UILabel()
        view.text = "전체 읽은 시간"
        view.font = Design.fontDefault
        view.textColor = Design.colorTextDefault
        view.numberOfLines = 0
        return view
    }()
    
    let readIteration = {
        let view = UILabel()
        view.text = "0번째 읽는중"
        view.font = Design.fontDefault
        view.textColor = Design.colorTextDefault
        view.numberOfLines = 0
        return view
    }()
    
    let introduction = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = ""
        view.font = Design.fontDefault
        view.textColor = Design.colorTextDefault
        return view
    }()
    
    let publisher = {
        let view = UILabel()
        view.text = "출판사"
        view.font = Design.fontDefault
        view.textColor = Design.colorTextDefault
        return view
    }()
    
    let isbn = {
        let view = UILabel()
        view.text = "ISBN"
        view.font = Design.fontDefault
        view.textColor = Design.colorTextDefault
        return view
    }()
    
    let page = {
        let view = UILabel()
        view.text = "페이지"
        view.font = Design.fontDefault
        view.textColor = Design.colorTextDefault
        return view
    }()
    
    var readButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "timer"), for: .normal)
        button.backgroundColor = Design.colorPrimaryAccent
        button.tintColor = Design.colorSecondaryAccent
        button.layer.cornerRadius = Design.paddingDefault
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowOpacity = 0.5
        button.setTitle("읽기", for: .normal)
        button.setTitleColor(Design.colorSecondaryAccent, for: .normal)
        return button
    }()
    
    var memoButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "note.text.badge.plus"), for: .normal)
        button.backgroundColor = Design.colorPrimaryAccent
        button.tintColor = Design.colorSecondaryAccent
        button.layer.cornerRadius = Design.paddingDefault
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowOpacity = 0.5
        button.setTitle("메모추가", for: .normal)
        button.setTitleColor(Design.colorSecondaryAccent, for: .normal)
        return button
    }()
    
    var startReadingButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "book"), for: .normal)
        button.setTitle(Literal.startReadingLabel, for: .normal)
        button.backgroundColor = Design.colorPrimaryAccent
        button.tintColor = Design.colorSecondaryAccent
        button.setTitleColor(Design.colorSecondaryAccent, for: .normal)
        button.layer.cornerRadius = Design.paddingDefault
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowOpacity = 0.5
        return button
    }()
}
