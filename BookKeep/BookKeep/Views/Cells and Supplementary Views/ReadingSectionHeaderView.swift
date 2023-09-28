//
//  ReadingSectionHeaderCollectionReusableView.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/27.
//

import UIKit
import SnapKit

final class ReadingSectionHeaderView: UICollectionReusableView {
    
    private let welcomeLabel = {
        let view = UILabel()
        view.text = Literal.mainGreeting
        view.font = Design.fontTitle
        view.textColor = Design.colorTextTitle
        return view
    }()
    
    private let welcomeSecondLabel = {
        let view = UILabel()
        view.text = Literal.subGreeting
        view.font = Design.fontDefault
        view.textColor = Design.colorTextSubTitle
        return view
    }()
    
    private func setViews(){
//        backgroundColor = .systemGray
        addSubview(welcomeLabel)
        addSubview(welcomeSecondLabel)
    }
    private func setConstraints(){
        welcomeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(Design.paddingDefault)
        }
        welcomeSecondLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom)
            make.leading.equalTo(welcomeLabel)
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
    func checkRegistration(){
        print("DEBUG:",self.description, "registered")
    }
}
