//
//  DetailTableViewSessionCell.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/18.
//

import UIKit
import SnapKit

class DetailTableViewSessionCell: UITableViewCell {
    static let identifier = "DetailTableViewSessionCell"
    var session: ReadSession?
    
    private let primaryLabel = {
        let view = UILabel()
        view.font = Design.fontDefault
        view.textColor = Design.colorTextDefault
        view.numberOfLines = 1
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
        primaryLabel.text = "\(session?.duration.converToValidFormat() ?? "") 동안, \(session?.endPage ?? -999).p 까지"
        secondaryLabel.text = "\(session?.startTime.formatted(date: .numeric, time: .shortened) ?? "")"
        
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
