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
        
        config.text = "시작: \(session?.startTime.formatted(date: .abbreviated, time: .shortened) ?? "")"
        config.secondaryText = "독서 시간: \(session?.duration.converToValidFormat() ?? "")  페이지: \(session?.endPage ?? -999).p"
        
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
