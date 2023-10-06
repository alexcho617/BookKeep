//
//  DetailTableHeader.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/06.
//

//기존 detailview 전체를 헤더로 한다.
// cell 에는 메모만 추가한다

import UIKit
import SnapKit
class DetailTableHeader: UITableViewHeaderFooterView {
    lazy var baseView = {
        let view = UIView()
        return view
    }()
    
    let bookTitle = DetailViewComponents.bookTitle
    let coverImageView = DetailViewComponents.coverImageView
    let author = DetailViewComponents.author
    let readButton = DetailViewComponents.readButton
    let memoButton = DetailViewComponents.memoButton
    let page = DetailViewComponents.page

    let introduction = DetailViewComponents.introduction
    let publisher = DetailViewComponents.publisher
    let isbn = DetailViewComponents.isbn
    
    lazy var infoStack = {
        let view = UIStackView(arrangedSubviews: [LabelViews.pageLabel,page,LabelViews.introductionLabel,introduction,LabelViews.publisherLabel,publisher, LabelViews.isbnLabel,isbn])
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = 4
        return view
    }()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setContents()
    }
    
    func setData(book: RealmBook){
        bookTitle.text = book.title
        coverImageView.kf.setImage(with: URL(string: book.coverUrl))
        author.text = book.author
        introduction.text = book.descriptionOfBook
        publisher.text = book.publisher
        isbn.text = book.isbn
        page.text = "\(book.currentReadingPage) / \(book.page)"
        
    }
    
    func setContents(){
        contentView.addSubview(baseView)
        contentView.addSubview(bookTitle)
        contentView.addSubview(coverImageView)
        contentView.addSubview(author)
        contentView.addSubview(readButton)
        contentView.addSubview(memoButton)
        contentView.addSubview(infoStack)

        
        baseView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(Design.paddingDefault)
        }
        
        bookTitle.snp.makeConstraints { make in
            make.top.width.equalTo(baseView)
        }
        
        coverImageView.snp.makeConstraints { make in
            make.top.equalTo(bookTitle.snp.bottom).offset(2*Design.paddingDefault)
            make.leading.equalTo(bookTitle)
            make.width.equalTo(baseView.snp.width).multipliedBy(0.4)
            make.height.equalTo(coverImageView.snp.width).multipliedBy(1.5)
        }
        
        author.snp.makeConstraints { make in
            make.top.equalTo(coverImageView)
            make.leading.equalTo(coverImageView.snp.trailing).offset(Design.paddingDefault)
            make.width.equalTo(baseView.snp.width).multipliedBy(0.55)
        }
        
        readButton.snp.makeConstraints { make in
            make.bottom.equalTo(coverImageView)
            make.leading.equalTo(coverImageView.snp.trailing).offset(2*Design.paddingDefault)
            make.width.equalTo(baseView.snp.width).multipliedBy(0.15)
            make.height.greaterThanOrEqualTo(32)
        }
        
        memoButton.snp.makeConstraints { make in
            make.bottom.equalTo(readButton)
            make.leading.equalTo(readButton.snp.trailing).offset(Design.paddingDefault)
            make.width.equalTo(baseView.snp.width).multipliedBy(0.15)
            make.height.greaterThanOrEqualTo(32)
        }
        //stackview
        infoStack.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(Design.paddingDefault)
            make.width.equalTo(baseView)
        }
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
