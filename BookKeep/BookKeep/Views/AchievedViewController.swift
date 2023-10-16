//
//  AchievedViewController.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/15.
//

import UIKit
import RealmSwift

final class AchievedViewController: UIViewController {
    //TODO: CollectionView 구현
    //TODO: CollectionView Header 구현
    //TODO: 쎌 선택시 DetailTableView에서 대응
    
    let vm = AchievedViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        setView()
    }
    
    private func setView(){
        view.backgroundColor = Design.colorPrimaryBackground
    }
    
    private func bindData(){
        vm.booksDoneReading.bind { [self] value in
            print("DEBUG: 다 읽은 책 갯수: \(value.count)")
            
            
        }
    }


}
