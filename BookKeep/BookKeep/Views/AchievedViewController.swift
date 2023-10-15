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
    var booksDoneReading: [RealmBook]!
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        setView()
        
        
        
       
    }
    
    private func setView(){
        view.backgroundColor = Design.colorPrimaryBackground
    }
    
    private func bindData(){
        vm.books.bind { [self] value in
            //TODO: Logic 확인
            //3번이나 실행되는데.... 필터 이거 괜찮나? 책이 일반적으로 1만개 이상 들어가진 않을텐데.. 문제는 홈뷰에서도 같은 로직임
            booksDoneReading = Array(value).filter { $0.readingStatus == .done }
            
        }
    }


}
