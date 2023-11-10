//
//  AchievedViewController.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/15.
//

import UIKit
import RealmSwift
import SnapKit

protocol AchievedDelegate: AnyObject {
    func reloadCollectionView()
}

final class AchievedViewController: UIViewController, AchievedDelegate {

    //views
    //TODO: v1.1 컬렉션 뷰 위에 차트 추가 
    private lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: getCollectionViewLayout())
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    let vm = AchievedViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        setView()
    }
    
    private func setView(){
        view.backgroundColor = Design.colorPrimaryAccent
        view.addSubview(collectionView)
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AchievedHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "AchievedHeaderCollectionReusableView")
        collectionView.register(ToReadCell.self, forCellWithReuseIdentifier: "ToReadCell")
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view).inset(Design.paddingDefault)
        }
    }
    
    private func bindData(){
        vm.booksDoneReading.bind { [self] value in
            collectionView.reloadData()
        }
    }
    
    private func getCollectionViewLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        //이걸 안하면 data source 실행 안됨
        layout.headerReferenceSize = .init(width: 100, height: 100)
        let itemSize = CGSize(width: UIScreen.main.bounds.width/2 - 2*Design.paddingDefault, height: 250) //2등분
        layout.minimumInteritemSpacing = Design.paddingDefault
        layout.minimumLineSpacing = Design.paddingDefault
        layout.itemSize = itemSize
        return layout
    }

}

extension AchievedViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func reloadCollectionView() {
//        print("DEBUG: AchievedVC -", #function)
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.booksDoneReading.value.count
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AchievedHeaderCollectionReusableView", for: indexPath) as? AchievedHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        header.welcomeLabel.text = Literal.achievedMainGreeting
//        header.welcomeLabel.text = Literal.achievedMainGreeting + " (\(vm.booksDoneReading.value.count))"
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBook = vm.booksDoneReading.value[indexPath.item]
        
        let vc = DetailTableViewController()
        vc.vm = DetailViewModel(isbn: selectedBook.isbn)
        vc.vm?.achievedDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}
