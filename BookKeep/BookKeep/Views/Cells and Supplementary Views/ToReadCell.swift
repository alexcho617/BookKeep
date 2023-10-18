//
//  ToReadCell.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/26.
//


import UIKit
import Kingfisher

final class ToReadCell: UICollectionViewCell {
    
    var book: RealmBook!
    
    var imageView = UIImageView()
    var title = UILabel()

    func setView(){
        guard let book = book else {return}
        contentView.backgroundColor = Design.colorPrimaryBackground
        contentView.layer.cornerRadius = Design.paddingDefault
        contentView.layer.shadowOffset = CGSize(width: 8, height: 8)
        contentView.layer.shadowOpacity = 0.5
        
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = Design.paddingDefault
        imageView.clipsToBounds = true
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: book.coverUrl))
        
      
        contentView.addSubview(title)
        title.text = book.title
        title.font = Design.fontDefault
        title.textColor = Design.colorTextDefault
        title.numberOfLines = 2
        
    }
    
    func setConstraints(){
        
        imageView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView)
            make.width.equalTo(contentView).multipliedBy(0.8)
            make.height.equalTo(imageView.snp.width).multipliedBy(1.4)
        }
        
        
        title.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(Design.paddingDefault)
            make.leading.equalTo(imageView).offset(Design.paddingDefault)
            make.trailing.equalTo(contentView.snp.trailing).offset(-Design.paddingDefault)
            
        }
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalTo(title.snp.bottom)
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
