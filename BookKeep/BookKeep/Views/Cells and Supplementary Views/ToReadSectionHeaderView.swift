//
//  ToReadSectionHeaderView.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/27.
//

import UIKit

final class ToReadSectionHeaderView: UICollectionReusableView {
    private let title = {
        let view = UILabel()
        view.text = "읽을 예정인 책"
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
        addSubview(title)
    }
    private func setConstraints(){
        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(Designs.defaultPadding)
            make.size.equalToSuperview().multipliedBy(0.5)
        }
     
    }
}
