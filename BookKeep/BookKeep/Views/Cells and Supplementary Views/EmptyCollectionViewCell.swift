//
//  EmptyCollectionViewCell.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/04.
//

import UIKit
import SnapKit

class EmptyCollectionViewCell: UICollectionViewCell {
    let label = {
        let view = UILabel()
        view.font = Design.fontAccentDefault
        view.textColor = Design.colorPrimaryAccent
        view.text = "책을 추가하세요 :)"
        return view
    }()

    //Codebase initialize
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(contentView)
        }
    }
    
    //Storyboard initialize
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
