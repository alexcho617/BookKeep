//
//  ReadingCell.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/26.
//

import UIKit
import Kingfisher

final class ReadingCell: UICollectionViewCell {
    
    var book: RealmBook!
    var title = UILabel()
    var imageView = UIImageView()
    var startDate = UILabel()
    var latestSessionDate = UILabel()
    var page = UILabel()
    var readIteration = UILabel()
    
    func setView(){
        guard let book = book else { return }
        contentView.backgroundColor = Design.colorSecondaryAccent
        contentView.layer.cornerRadius = Design.paddingDefault
        contentView.addSubview(title)
        title.text = book.title
        title.font = Design.fontSubTitle
        title.textColor = .label
        title.numberOfLines = 0
        
        
        contentView.addSubview(imageView)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: book.coverUrl))
        imageView.backgroundColor = Design.debugBlue
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Design.paddingDefault
        imageView.layer.borderColor = Design.colorPrimaryAccent?.cgColor
        imageView.layer.borderWidth = 2
        
        contentView.addSubview(startDate)
        startDate.text = "시작: " + (book.startDate.formatted(date: .numeric, time: .omitted) )
        startDate.font = Design.fontDefault
        startDate.textColor = .secondaryLabel
        
        contentView.addSubview(latestSessionDate)
        latestSessionDate.text = "최근 독서: " + (book.readSessions.last?.startTime.formatted(date: .numeric, time: .omitted) ?? " - " )
        latestSessionDate.font = Design.fontDefault
        latestSessionDate.textColor = .secondaryLabel
        
        contentView.addSubview(page)
        page.text = "\(book.currentReadingPage) / \(book.page) p"
        page.font = Design.fontDefault
        page.textColor = .secondaryLabel
        
        contentView.addSubview(readIteration)
        readIteration.text = book.readIteration == 0 ? "처음 읽는 중": "\(book.readIteration + 1)번째 읽는 중"
        readIteration.font = Design.fontDefault
        readIteration.textColor = .secondaryLabel
//        contentView.addSubview(readButton)
//        contentView.addSubview(memoButton)

    }
    
    func setConstraint(){
        title.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView).inset(Design.paddingDefault)
            make.height.equalTo(32)
            
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(Design.paddingDefault)
            make.top.equalTo(title.snp.bottom).offset(Design.paddingDefault)
            make.width.equalTo(contentView).multipliedBy(0.4)
            make.height.equalTo(imageView.snp.width).multipliedBy(1.4)
        }
        
        startDate.snp.makeConstraints { make in
            make.top.equalTo(imageView).offset(Design.paddingDefault)
            make.leading.equalTo(imageView.snp.trailing).offset(Design.paddingDefault)
            make.trailing.lessThanOrEqualToSuperview().offset(-Design.paddingDefault)
        }
        
        latestSessionDate.snp.makeConstraints { make in
            make.top.equalTo(startDate.snp.bottom).offset(Design.paddingDefault)
            make.leading.equalTo(startDate)
            make.trailing.lessThanOrEqualToSuperview().offset(-Design.paddingDefault)

        }
        page.snp.makeConstraints { make in
            make.top.equalTo(latestSessionDate.snp.bottom).offset(Design.paddingDefault)
            make.leading.equalTo(startDate)
            make.trailing.lessThanOrEqualToSuperview().offset(-Design.paddingDefault)

        }
        readIteration.snp.makeConstraints { make in
//            make.top.equalTo(page.snp.bottom).offset(Design.paddingDefault)
//            make.leading.equalTo(startDate)
//            make.trailing.lessThanOrEqualToSuperview().offset(-Design.paddingDefault)
            make.trailing.equalToSuperview().offset(-2 * Design.paddingDefault)
            make.bottom.equalToSuperview().offset(-Design.paddingDefault)

        }
//        memoButton.snp.makeConstraints { make in
//            make.centerY.equalTo(contentView.snp.bottom)
//            make.trailing.equalTo(contentView.snp.trailing).offset(-Design.paddingDefault)
//            make.width.equalTo(contentView.snp.width).multipliedBy(0.15)
//            make.height.greaterThanOrEqualTo(32)
//
//        }
//
//        readButton.snp.makeConstraints { make in
//            make.centerY.equalTo(contentView.snp.bottom)
//            make.trailing.equalTo(memoButton.snp.leading).offset(-Design.paddingDefault)
//            make.width.equalTo(contentView.snp.width).multipliedBy(0.15)
//            make.height.greaterThanOrEqualTo(32)
//
//        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
