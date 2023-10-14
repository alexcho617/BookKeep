//
//  DetailTableFooter.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/14.
//

import UIKit
import SnapKit
class DetailTableFooter: UITableViewHeaderFooterView {
    let aladinButton = {
        let view = UIButton()
        view.setTitle("도서 DB 제공: 알라딘", for: .normal)
        view.titleLabel?.font = Design.fontSmall
        view.setTitleColor(Design.colorTextDefault, for: .normal)
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setView()
    }
    
    func setView(){
        contentView.addSubview(aladinButton)
        aladinButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
