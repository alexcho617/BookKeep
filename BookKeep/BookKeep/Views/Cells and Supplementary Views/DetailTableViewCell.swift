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
        print(memo)
        textLabel?.text = memo?.contents
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
