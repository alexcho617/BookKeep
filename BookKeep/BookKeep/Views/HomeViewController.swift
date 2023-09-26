//
//  ViewController.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/25.
//

import UIKit

final class HomeViewController: UIViewController {

    //Views
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setView()
        setConstraints()
    }
    func setView(){
        
    }
    
    func setConstraints(){
        
    }
    func createCollectionViewLayout() -> UICollectionViewLayout{
        return UICollectionViewLayout()
    }


}

