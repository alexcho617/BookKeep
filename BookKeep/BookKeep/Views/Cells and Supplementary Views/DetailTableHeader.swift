//
//  DetailTableHeader.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/06.
//

import UIKit
import SnapKit

final class DetailTableHeader: UITableViewHeaderFooterView {
    var detailBook: RealmBook?
    var vm: DetailViewModel?
    weak var delegate: DiffableDataSourceDelegate? //section 이동
    var memoButtonAction: (() -> Void)? // Closure property to hold the action for memoButton click

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
    let startReadingButton = DetailViewComponents.startReadingButton
    
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
        bindData()
    }
    func bindData(){
        vm?.book.bind({ [self] book in
            setData()
            setViews()
        })
    }
    func setData(){
        guard let detailBook = detailBook else {return}
        bookTitle.text = detailBook.title
        coverImageView.kf.setImage(with: URL(string: detailBook.coverUrl))
        author.text = detailBook.author
        introduction.text = detailBook.descriptionOfBook
        publisher.text = detailBook.publisher
        isbn.text = detailBook.isbn
        page.text = "\(detailBook.currentReadingPage) / \(detailBook.page)"
        
    }
    
    func setViews(){
        guard let detailBook = detailBook else {return}
        
        contentView.addSubview(baseView)
        contentView.addSubview(bookTitle)
        contentView.addSubview(coverImageView)
        contentView.addSubview(author)
        
        baseView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        bookTitle.snp.makeConstraints { make in
            make.top.width.equalTo(baseView).offset(Design.paddingDefault)
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
        
        if detailBook.readingStatus == .reading{
            contentView.addSubview(readButton)
            contentView.addSubview(memoButton)
            memoButton.addTarget(self, action: #selector(memoButtonClicked), for: .touchUpInside)
            contentView.addSubview(infoStack)
            
            
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
                make.leading.trailing.equalTo(baseView)
                make.bottom.lessThanOrEqualTo(baseView).offset(-5*Design.paddingDefault).priority(.high)// Specify a bottom constraint
            }
        }else if detailBook.readingStatus == .toRead{
            contentView.addSubview(startReadingButton)
            startReadingButton.addTarget(self, action: #selector(startReadingClicked), for: .touchUpInside)
            
            startReadingButton.snp.makeConstraints { make in
                make.top.equalTo(coverImageView.snp.bottom).offset(Design.paddingDefault)
                make.horizontalEdges.equalTo(baseView)
                
                make.bottom.lessThanOrEqualTo(baseView).offset(-5*Design.paddingDefault).priority(.high)// Specify a bottom constraint

            }
        }
     
    }
    
    @objc func startReadingClicked(){
        print(#function)
        startReadingButton.isHidden = true
        vm?.startReading()
    }
    
    @objc func memoButtonClicked(){
        memoButtonAction?()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
