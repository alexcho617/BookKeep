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
    
    func setView(){
        layer.borderColor = Design.colorPrimaryAccent?.cgColor
        layer.borderWidth = 1
        var config = self.defaultContentConfiguration()
        backgroundColor = Design.colorPrimaryBackground
        
        config.text = memo?.contents
        config.secondaryText = memo?.date.formatted(.dateTime)
        
        config.textProperties.font = Design.fontAccentDefault
        config.textProperties.color = Design.colorTextDefault
        config.textProperties.numberOfLines = 3
        
        config.secondaryTextProperties.font = Design.fontDefault
        config.secondaryTextProperties.color = Design.colorTextDefault
        
        self.contentConfiguration = config
        selectionStyle = .none
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
