//
//  DetailTableViewSessionCell.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/18.
//

import UIKit

class DetailTableViewSessionCell: UITableViewCell {
    static let identifier = "DetailTableViewSessionCell"
    var session: ReadSession?
    
    func setView(){
        layer.borderColor = Design.colorPrimaryAccent?.cgColor
        layer.borderWidth = 1
        var config = self.defaultContentConfiguration()
        backgroundColor = Design.colorPrimaryBackground
        
        config.text = "\(session?.duration.converToValidFormat() ?? "") 동안, \(session?.endPage ?? -999).p 까지"
        config.secondaryText = "\(session?.startTime.formatted(date: .numeric, time: .shortened) ?? "")"
        
        config.textProperties.font = Design.fontDefault
        config.textProperties.color = Design.colorTextDefault
        config.textProperties.numberOfLines = 3
        
        config.secondaryTextProperties.font = Design.fontSmall
        config.secondaryTextProperties.color = Design.colorTextDefault
        
        self.contentConfiguration = config
        selectionStyle = .none
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
