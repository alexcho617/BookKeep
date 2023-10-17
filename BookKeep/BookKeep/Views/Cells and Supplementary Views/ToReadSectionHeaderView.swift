//
//  ToReadSectionHeaderView.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/27.
//

import UIKit

final class ToReadSectionHeaderView: UICollectionReusableView {
    
    var title = {
        let view = UILabel()
        view.text = Literal.secondSectionLabel
        view.font = Design.fontSubTitle
        view.textColor = Design.colorTextSubTitle
        view.backgroundColor = Design.colorPrimaryBackground
        view.textAlignment = .center
        return view
    }()
    
    private func setViews(){
        addSubview(title)
        title.layer.cornerRadius = Design.paddingDefault
        title.clipsToBounds = true
    }
    private func setConstraints(){
        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(Design.paddingDefault)
            make.width.greaterThanOrEqualToSuperview().multipliedBy(0.5) //최소 설정
        }
     
    }
    
    //Codebase initialize
    override init(frame: CGRect){
        super.init(frame: frame)
        setViews()
        setConstraints()
    }
    
    //Storyboard initialize
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
   
}
