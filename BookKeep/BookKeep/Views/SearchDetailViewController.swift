//
//  SearchDetailViewController.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/30.
//

import UIKit
import SnapKit

class SearchDetailViewController: UIViewController {
    var isbn13: String = ""
    
    
    var bookTitle = UILabel()
    var coverImageView = UIImageView()
    var author = UILabel()
    var introduction = UILabel()
    var publisher = UILabel()
    var isbn = UILabel()
    var page = UILabel()
    var baseView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraints()

    }
    
    func addToReadingList(){
        //create RealmBook Object
        //add to realm
        //go back to homescreen: 1.pop until homeview or 2.change rootview by using makeKeyAndVisible
    }
    func setView(){
        baseView = addBaseView()
        view.addSubview(baseView)
        
    }
    func setConstraints(){
        baseView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
    }
    deinit {
        print("SearchDetailViewController deinit")
    }

}
