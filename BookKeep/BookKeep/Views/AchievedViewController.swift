//
//  AchievedViewController.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/15.
//

import UIKit
import RealmSwift
import SnapKit

final class AchievedViewController: UIViewController {
    
    //TODO: CollectionView Header 구현
    //TODO: Collectionview cell 구현
    //TODO: 쎌 선택시 DetailTableView에서 대응
    
    //views
    private lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: getCollectionViewLayout())
        view.backgroundColor = Design.debugBlue
        return view
    }()
    
    let vm = AchievedViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        setView()
    }
    
    private func setView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AchievedHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "AchievedHeaderCollectionReusableView")
        collectionView.register(ToReadCell.self, forCellWithReuseIdentifier: "ToReadCell")
        view.backgroundColor = Design.colorPrimaryBackground
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(Design.paddingDefault)
        }
    }
    
    private func bindData(){
        vm.booksDoneReading.bind { [self] value in
            collectionView.reloadData()
            
            
        }
    }
    
    private func getCollectionViewLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        let itemSize = CGSize(width: UIScreen.main.bounds.width/2 - 2*Design.paddingDefault, height: 250) //3등분
        layout.minimumInteritemSpacing = Design.paddingDefault
        layout.minimumLineSpacing = Design.paddingDefault
        layout.itemSize = itemSize
        return layout
    }


}

extension AchievedViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let numberOfItems = vm.booksDoneReading.value.count
        print(#function, numberOfItems)
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //ToReadCell로 일단 테스트
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToReadCell", for: indexPath) as? ToReadCell else {return UICollectionViewCell()}
        let item = vm.booksDoneReading.value[indexPath.item]
        cell.book = item
        cell.setView()
        cell.setConstraints()
        return cell
    }
    
    
    //TODO: Header 안나옴
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "AchievedHeaderCollectionReusableView",
                for: indexPath
              ) as? AchievedHeaderCollectionReusableView else {return UICollectionReusableView()}
        return header
    }
}
