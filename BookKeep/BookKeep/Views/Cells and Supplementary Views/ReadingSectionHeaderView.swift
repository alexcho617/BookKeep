//
//  ReadingSectionHeaderCollectionReusableView.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/27.
//

import UIKit
import SnapKit

final class ReadingSectionHeaderView: UICollectionReusableView {
    
    var eventHandler: (() -> Void)?
    
    let welcomeLabel = {
        let view = UILabel()
        view.text = Literal.mainGreeting
        view.font = Design.fontTitle
        view.textColor = Design.colorTextTitle
        return view
    }()
    
    let welcomeSecondLabel = {
        let view = UILabel()
        view.text = Literal.subGreeting
        view.font = Design.fontDefault
        view.textColor = Design.colorSecondaryBackground
        return view
    }()
    
    private let addButton = {
        let view = UIButton()
        view.setTitle("책 추가하기", for: .normal)
        view.setTitleColor(Design.colorSecondaryAccent, for: .normal)
        view.backgroundColor = Design.colorPrimaryAccent
        view.titleLabel?.font = Design.fontAccentDefault
        view.titleLabel?.textAlignment = .center
        view.layer.cornerRadius = Design.paddingDefault
        view.layer.borderWidth = 2
        view.layer.borderColor = Design.colorSecondaryAccent?.cgColor
        return view
    }()
    
    private func setViews(){
        addSubview(welcomeLabel)
        addSubview(welcomeSecondLabel)
        addSubview(addButton)
        addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
    }
    private func setConstraints(){
        welcomeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(2*Design.paddingDefault)
        }
        
        welcomeSecondLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom)
            make.leading.equalTo(welcomeLabel)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-Design.paddingDefault)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
    }
    @objc func addButtonClicked(){
        eventHandler?()
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
