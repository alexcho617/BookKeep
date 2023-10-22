//
//  SearchCollectionViewCell.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/29.
//

import UIKit
import Kingfisher
import SnapKit

class SearchCollectionViewCell: UICollectionViewCell {
    static let identifier = "SearchCollectionViewCell"
    var item: Item!
    //제목
    //커버
    //저자
    //출판사
    let baseView = UIView()
    let title = UILabel()
    let coverImage = UIImageView()
    let author = UILabel()
    let publisher = UILabel()
    
    func setView(){
        guard let item = item else {return}
        contentView.addSubview(baseView)
        baseView.backgroundColor = Design.colorSecondaryAccent
        baseView.layer.cornerRadius = Design.paddingDefault
//        baseView.layer.shadowOffset = CGSize(width: 8, height: 8)
//        baseView.layer.shadowOpacity = 0.5
        
        
        contentView.addSubview(title)
        title.font = Design.fontAccentDefault
        title.text = item.title
        title.textColor = Design.colorTextSubTitle
        title.numberOfLines = 2
        
        contentView.addSubview(coverImage)
        coverImage.kf.indicatorType = .activity
        coverImage.kf.setImage(with: URL(string: item.cover))
        coverImage.backgroundColor = .black
        coverImage.contentMode = .scaleAspectFill
        coverImage.clipsToBounds = true
        coverImage.layer.borderColor = Design.colorPrimaryAccent?.cgColor
        coverImage.layer.borderWidth = 2
        
        contentView.addSubview(author)
        author.font = Design.fontDefault
        author.text = item.author
        author.textColor = Design.colorTextDefault
        author.numberOfLines = 1
        
        
        contentView.addSubview(publisher)
        publisher.text = item.publisher
        publisher.font = Design.fontDefault
        publisher.textColor = Design.colorTextDefault
        publisher.numberOfLines = 1
        
    }
    
    func setConstraints(){
        baseView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(Design.paddingDefault)
        }
        coverImage.snp.makeConstraints { make in
            make.leading.equalTo(baseView).offset(Design.paddingDefault)
            make.top.equalTo(baseView).offset(Design.paddingDefault)
            make.width.equalTo(baseView).multipliedBy(0.2)
            make.height.equalTo(coverImage.snp.width).multipliedBy(1.4)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(coverImage)
            make.leading.equalTo(coverImage.snp.trailing).offset(Design.paddingDefault)
            make.trailing.equalTo(baseView)
        }
        author.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(Design.paddingDefault)
            make.leading.equalTo(title)
            make.trailing.equalTo(baseView)

        }
        
        publisher.snp.makeConstraints { make in
            make.top.equalTo(author.snp.bottom).offset(Design.paddingDefault)
            make.leading.equalTo(author)
            make.trailing.equalTo(baseView)

        }
    }
    
    //Codebase initialize
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    //Storyboard initialize
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
