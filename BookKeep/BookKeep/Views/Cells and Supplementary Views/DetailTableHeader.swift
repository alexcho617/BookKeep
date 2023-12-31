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
    var memoButtonAction: (() -> Void)?
    var readButtonAction: (() -> Void)?
    
    //Init 으로  컴포넌트들을 받으면 lazy가 필요없지 않을까?
    private let viewComponents = DetailViewComponents()
    private let labelViews = LabelViews()
    
    
    lazy var baseView = {
        let view = UIView()
        return view
    }()
    
    
    lazy var bookTitle = viewComponents.bookTitle
    lazy var coverImageView = viewComponents.coverImageView
    lazy var author = viewComponents.author
    lazy var readButton = viewComponents.readButton
    lazy var memoButton = viewComponents.memoButton
    lazy var page = viewComponents.page
    lazy var totalReadTime = viewComponents.totalReadTime
    lazy var readIteration = viewComponents.readIteration
    
    let startReadingButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "book"), for: .normal)
        button.setTitle(Literal.startReadingLabel, for: .normal)
        button.backgroundColor = Design.colorPrimaryAccent
        button.tintColor = Design.colorSecondaryAccent
        button.setTitleColor(Design.colorSecondaryAccent, for: .normal)
        button.layer.cornerRadius = Design.paddingDefault
        return button
    }()
    
    lazy var introduction = viewComponents.introduction
    lazy var publisher = viewComponents.publisher
    lazy var isbn = viewComponents.isbn
    
    lazy var infoStack = {
        let view = UIStackView(arrangedSubviews: [
            labelViews.pageLabel,page,
            labelViews.introductionLabel,introduction,
            labelViews.publisherLabel,publisher,
            labelViews.isbnLabel,isbn])
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = 4
        view.setCustomSpacing(2*Design.paddingDefault, after: page)
        view.setCustomSpacing(2*Design.paddingDefault, after: introduction)
        view.setCustomSpacing(2*Design.paddingDefault, after: publisher)
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        print("DEBUG: DetailHeader Init")
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
        coverImageView.kf.indicatorType = .activity
        coverImageView.kf.setImage(with: URL(string: detailBook.coverUrl))
        author.text = detailBook.author
        introduction.text = detailBook.descriptionOfBook
        publisher.text = detailBook.publisher
        isbn.text = detailBook.isbn
        page.text = "\(detailBook.currentReadingPage) / \(detailBook.page)"
        totalReadTime.text =  "총 읽은 시간: " + (detailBook.calculateTotalReadTime().converToValidFormat() ?? "-")
        
        if detailBook.readingStatus == .reading{
            readIteration.text = detailBook.readIteration == 0 ? "처음 읽는 중": "\(detailBook.readIteration + 1)번째 읽는 중"
        }else {
            readIteration.text = "\(detailBook.readIteration)번 읽음"
        }
        
    }
    
    func setViews(){
        guard let detailBook = detailBook else {return}
        
        contentView.addSubview(baseView)
        contentView.addSubview(bookTitle)
        contentView.addSubview(coverImageView)
        contentView.addSubview(author)
        contentView.addSubview(totalReadTime)
        contentView.addSubview(readIteration)
        
        baseView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        bookTitle.snp.makeConstraints { make in
            make.top.equalTo(baseView).offset(3*Design.paddingDefault)
            make.width.equalTo(baseView)
            make.leading.equalTo(baseView)
        }
        
        coverImageView.snp.makeConstraints { make in
            make.top.equalTo(bookTitle.snp.bottom).offset(2*Design.paddingDefault)
            make.leading.equalTo(bookTitle.snp.leading)
            make.width.equalTo(baseView.snp.width).multipliedBy(0.4)
            make.height.equalTo(coverImageView.snp.width).multipliedBy(1.5)
        }
        
        author.snp.makeConstraints { make in
            make.top.equalTo(coverImageView)
            make.leading.equalTo(coverImageView.snp.trailing).offset(Design.paddingDefault)
            make.width.equalTo(baseView.snp.width).multipliedBy(0.55)
        }
        
        totalReadTime.snp.makeConstraints { make in
            make.leading.equalTo(author)
            make.top.equalTo(author.snp.bottom).offset(Design.paddingDefault)
            make.trailing.lessThanOrEqualTo(baseView).offset(-Design.paddingDefault)
        }
        
        readIteration.snp.makeConstraints { make in
            make.leading.equalTo(author)
            make.top.equalTo(totalReadTime.snp.bottom).offset(Design.paddingDefault)
            make.trailing.equalTo(totalReadTime.snp.trailing)
        }
        
        switch detailBook.readingStatus{
            
        case .reading, .done:
            startReadingButton.isHidden = true
           
            contentView.addSubview(memoButton)
            memoButton.addTarget(self, action: #selector(memoButtonClicked), for: .touchUpInside)
            contentView.addSubview(infoStack)
            
            if detailBook.readingStatus == .reading{
                contentView.addSubview(readButton)
                readButton.addTarget(self, action: #selector(readButtonClicked), for: .touchUpInside)
                readButton.snp.makeConstraints { make in
                    make.bottom.equalTo(coverImageView)
                    make.leading.equalTo(coverImageView.snp.trailing).offset(2*Design.paddingDefault)
                    make.width.greaterThanOrEqualTo(baseView.snp.width).multipliedBy(0.2)
                    make.height.greaterThanOrEqualTo(32)
                }
                memoButton.snp.makeConstraints { make in
                    make.bottom.equalTo(readButton)
                    make.leading.equalTo(readButton.snp.trailing).offset(Design.paddingDefault)
                    make.width.greaterThanOrEqualTo(baseView.snp.width).multipliedBy(0.3)
                    make.height.greaterThanOrEqualTo(32)
                }
            }else{
                memoButton.snp.makeConstraints { make in
                    make.bottom.equalTo(coverImageView)
                    make.leading.equalTo(coverImageView.snp.trailing).offset(2*Design.paddingDefault)
                    make.width.greaterThanOrEqualTo(baseView.snp.width).multipliedBy(0.3)
                    make.height.greaterThanOrEqualTo(32)
                }
            }
            //stackview
            infoStack.snp.makeConstraints { make in
                make.top.equalTo(coverImageView.snp.bottom).offset(Design.paddingDefault)
                make.leading.trailing.equalTo(baseView)
                make.bottom.lessThanOrEqualTo(baseView).offset(-5*Design.paddingDefault).priority(.high) //이거 지정해줘야함.
            }
        case .toRead:
            contentView.addSubview(startReadingButton)
            startReadingButton.isHidden = false
            startReadingButton.addTarget(self, action: #selector(startReadingClicked), for: .touchUpInside)
            
            startReadingButton.snp.makeConstraints { make in
                make.top.equalTo(coverImageView.snp.bottom).offset(Design.paddingDefault)
                make.horizontalEdges.equalTo(baseView)
                make.height.greaterThanOrEqualTo(40)
                make.bottom.lessThanOrEqualTo(baseView).offset(-5*Design.paddingDefault).priority(.high) //이거 지정해줘야함.
            }

        case .paused, .stopped:
            return
        }
        
    }
    
    //this is from the startReadingButton
    @objc func startReadingClicked(){
        print(#function)
        startReadingButton.isHidden = true
        vm?.startReading(isAgain: false, handler: {
            
        })
    }
    
    @objc func memoButtonClicked(){
        memoButtonAction?()
    }
    @objc func readButtonClicked(){
        readButtonAction?()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DEBUG: DetailHeader Deinit")
    }
}
