//
//  SampleHeader.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/07.
//

import UIKit

class TableHeader: UITableViewHeaderFooterView{
    static let id = "TableHeader"
    
    private let image: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "star")
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Star my star"
        label.font = Design.fontSubTitle
        return label
    }()
    //Codebase initialize
    override init(reuseIdentifier: String?){
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    //Storyboard initialize
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(label)
        contentView.addSubview(image)
        contentView.backgroundColor = Design.debugBlue
        label.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.leading.equalTo(contentView).offset(10)
            make.width.equalTo(contentView)
        }
        
        image.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
}
