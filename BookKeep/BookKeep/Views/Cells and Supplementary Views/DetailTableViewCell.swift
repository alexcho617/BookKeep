//
//  DetailTableViewCell.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/06.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    static let identifier = "DetailTableViewCell"
    var memo: Memo?
    
    private let primaryLabel = {
        let view = UILabel()
        view.font = Design.fontDefault
        view.textColor = Design.colorTextDefault
        view.numberOfLines = 3
        return view
    }()
    
    private let secondaryLabel = {
        let view = UILabel()
        view.font = Design.fontSmall
        view.textColor = Design.colorTextDefault
        return view
    }()
    
    
    func setView(){
        selectionStyle = .none
        backgroundColor = Design.colorPrimaryBackground
        contentView.addSubview(primaryLabel)
        contentView.addSubview(secondaryLabel)
        primaryLabel.text = memo?.contents
        secondaryLabel.text = memo?.date.formatted(.dateTime)
        
        primaryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Design.paddingDefault)
            make.horizontalEdges.equalToSuperview().inset(Design.paddingDefault)
            
        }
        secondaryLabel.snp.makeConstraints { make in
            make.top.equalTo(primaryLabel.snp.bottom).offset(4)
            make.trailing.equalToSuperview().inset(Design.paddingDefault)
            make.bottom.equalToSuperview().offset(-Design.paddingDefault)
        }
    }
    
    
//    func setView(){
////        layer.borderColor = Design.colorPrimaryAccent?.cgColor
////        layer.borderWidth = 1
//        var config = self.defaultContentConfiguration()
//        backgroundColor = Design.colorPrimaryBackground
//
//        config.text = memo?.contents
//        config.secondaryText = memo?.date.formatted(.dateTime)
//
//        config.textProperties.font = Design.fontDefault
//        config.textProperties.color = Design.colorTextDefault
//        config.textProperties.numberOfLines = 3
//
//        config.secondaryTextProperties.font = Design.fontSmall
//        config.secondaryTextProperties.color = Design.colorTextDefault
//
//        self.contentConfiguration = config
//        selectionStyle = .none
//
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
