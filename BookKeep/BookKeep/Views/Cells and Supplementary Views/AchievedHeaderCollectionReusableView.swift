//
//  AchievedHeaderCollectionReusableView.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/17.
//

import UIKit

class AchievedHeaderCollectionReusableView: UICollectionReusableView {
  
    
    let welcomeLabel = {
        let view = UILabel()
        view.text = Literal.achievedMainGreeting
        view.font = Design.fontTitle
        view.textColor = Design.colorTextTitle
        return view
    }()
    
    let welcomeSecondLabel = {
        let view = UILabel()
        view.text = Literal.achievedSubGreeting
        view.font = Design.fontDefault
        view.textColor = Design.colorSecondaryBackground
        return view
    }()
    

    
    private func setViews(){
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
}
