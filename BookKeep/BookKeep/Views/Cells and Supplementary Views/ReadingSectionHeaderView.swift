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
        view.text = "어서오세요 :)"
        return view
    }()
    private let welcomeSecondLabel = {
        let view = UILabel()
        view.text = "오늘은 어떤 마음의 양식을 드셨나요?"
        return view
    }()
    
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
    private func setViews(){
        backgroundColor = .systemGray
        addSubview(welcomeLabel)
        addSubview(welcomeSecondLabel)
    }
    private func setConstraints(){
        welcomeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(Designs.defaultPadding)
            make.size.equalToSuperview().multipliedBy(0.5)
        }
        welcomeSecondLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(Designs.defaultPadding)
            make.leading.equalTo(welcomeLabel)
        }
    }
}
