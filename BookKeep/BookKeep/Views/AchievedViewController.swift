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
        title = "업적"

        let appearance = UINavigationBarAppearance()
        appearance.shadowImage = UIImage()
        appearance.backgroundImage = UIImage()
        appearance.backgroundColor = Design.colorPrimaryAccent
        navigationController?.navigationBar.tintColor = Design.colorPrimaryBackground
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AchievedHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "AchievedHeaderCollectionReusableView")
        collectionView.register(ToReadCell.self, forCellWithReuseIdentifier: "ToReadCell")
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view)
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
        print("DEBUG: AchievedVC -", #function)
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
        header.welcomeLabel.text = Literal.achievedMainGreeting + " (\(vm.booksDoneReading.value.count))"
        return header
    }
    //TODO: 쎌 선택시 DetailTableView에서 대응
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBook = vm.booksDoneReading.value[indexPath.item]
        
        //사실상 새로운 객체는 아니고 새로운 포인터
        let vc = DetailTableViewController() //isbn만 vc에 넘겨주고 vm은 알아서 생성하도록 하자 아니면 책을 넘기던가
        vc.vm = DetailViewModel(isbn: selectedBook.isbn)
        vc.vm?.achievedDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}
