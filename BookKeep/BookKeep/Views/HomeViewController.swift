//
//  ViewController.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/25.
//

import UIKit
import SnapKit
import Kingfisher
import RealmSwift

final class HomeViewController: UIViewController, UICollectionViewDelegate {
    
    //Variables
    let vm = HomeViewModel()
    var dataSource: UICollectionViewDiffableDataSource<SectionLayoutKind, RealmBook>!
    var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, RealmBook>()
    
    //Views
    var collectionView: UICollectionView! = nil
    var baseView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        setViewDesign()
        setConstraints()
        configureDataSource()
        bindData()
        //MARK: DEBUG
        BooksRepository.shared.realmURL()
        
    }
    
    private func configureHierarchy(){
        baseView = addBaseView()
        view.addSubview(baseView)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayoutBySection())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.delegate = self
        snapshot.appendSections([.homeReading,.homeToRead])
        
    }
    
    private func setConstraints(){
        baseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    private func setViewDesign(){
        collectionView.backgroundColor = .clear
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Design.colorPrimaryAccent
        let buttonAppearance = UIBarButtonItemAppearance()
        appearance.buttonAppearance = buttonAppearance
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = Design.colorPrimaryBackground
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.hidesBarsOnSwipe = true
        title = "홈"
        
    }
}

//MARK: Enums
extension HomeViewController{
    //Diffable: 섹션 종류
    enum SectionLayoutKind: Int, CaseIterable{
        case homeReading
        case homeToRead
        var columnCount: Int{
            switch self{
            case .homeReading:
                return 1
            case .homeToRead:
                return 2
            }
        }
    }
    
    //Diffable: 헤더 종류
    enum SectionSupplementaryKind: String{
        case readingHeader
        case toReadHeader
    }
}

//MARK: Layout
extension HomeViewController{
    //섹션에 따라 다른 레이아웃 적용
    private func generateLayoutBySection() -> UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let sectionKind = SectionLayoutKind(rawValue: sectionIndex)
            switch sectionKind{
            case .homeReading: return self.createBooksReadingLayout()
            case .homeToRead: return self.createBooksToReadLayout()
            case .none:
                return self.createBooksReadingLayout()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        layout.configuration = config
        return layout
    }
    
    //MARK: Reading Section Layout
    //가로 스크롤, 셀 하나씩 보여주는 섹션
    private func createBooksReadingLayout() -> NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(2/3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupFractionalWidth = 0.90
        let groupFractionalHeight: Float = 0.65
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(CGFloat(groupFractionalWidth)),
            heightDimension: .fractionalWidth(CGFloat(groupFractionalHeight)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 5,
            bottom: 5,
            trailing: 5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        //Header Layout
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.3))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: SectionSupplementaryKind.readingHeader.rawValue, alignment: .top)
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    //MARK: To Read Section Layout
    //세로 스크롤, 셀 두개씩 보여주는 섹션
    private func createBooksToReadLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        
        //TODO: 현재 셀이 타이틀 길이에 따라 높이가 달라지고 있는데 itemsize가 변경되지않고있음. 타이틀 길이에 따라 길이가 변하도록 변경
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        //Header Layout
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.2))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: SectionSupplementaryKind.toReadHeader.rawValue, alignment: .top)
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
}

//MARK: DataSource
extension HomeViewController{
    private func configureDataSource(){
        //Cell Register
        //MARK: TODO ⚠️ 셀이 혼용되어 사용되어지고 있음
        let readingCellRegistration = UICollectionView.CellRegistration<ReadingCell, RealmBook> { cell, indexPath, itemIdentifier in
            DispatchQueue.main.async {
                cell.book = itemIdentifier
                cell.setView()
                cell.setConstraint()
            }
        }
        
        let toReadCellRegistration = UICollectionView.CellRegistration<ToReadCell, RealmBook> { cell, indexPath, itemIdentifier in
            DispatchQueue.main.async {
                cell.book = itemIdentifier
                cell.setView()
                cell.setConstraints()
            }
        }
        
        //Supplementary Register
        let readingHeaderRegistration = UICollectionView.SupplementaryRegistration<ReadingSectionHeaderView>(elementKind: SectionSupplementaryKind.readingHeader.rawValue) { supplementaryView, elementKind, indexPath in
            supplementaryView.eventHandler = {
                self.present(UINavigationController(rootViewController: SearchViewController()), animated: true)
            }
        }
        
        let toReadHeaderRegistration = UICollectionView.SupplementaryRegistration<ToReadSectionHeaderView>(elementKind: SectionSupplementaryKind.toReadHeader.rawValue) { supplementaryView, elementKind, indexPath in
            //여기서 cell 처럼 header view 코드 실행 가능
        }
        
        //DS
        dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, RealmBook>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            //기존 index path기반으로 결정했던걸 itemidentifier.ReadingStatus 즉데이터 기반으로 변경
            let status = itemIdentifier.readingStatus
            print(itemIdentifier)
            switch status {
            case .reading:
                return collectionView.dequeueConfiguredReusableCell(using: readingCellRegistration, for: indexPath, item: itemIdentifier)
            case .toRead:
                return collectionView.dequeueConfiguredReusableCell(using: toReadCellRegistration, for: indexPath, item: itemIdentifier)
            default:
                return collectionView.dequeueConfiguredReusableCell(using: toReadCellRegistration, for: indexPath, item: itemIdentifier)
            }
        })
        
        //Header apply
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            let headerType = SectionSupplementaryKind(rawValue: kind)
            switch headerType{
            case .readingHeader:
                return self.collectionView.dequeueConfiguredReusableSupplementary(using:  readingHeaderRegistration, for: index)
            case .toReadHeader:
                return self.collectionView.dequeueConfiguredReusableSupplementary(using:  toReadHeaderRegistration, for: index)
            case .none:
                return UICollectionReusableView()
            }
        }
    }
    
    private func bindData(){
        //item 섹션은 잘 바뀌고 있으나 섹션에 사용되는 아이템의 cell타입이 변경되지않음. cellReuse랑 관련될 수도?
        
        //차안으로 스냅샷 자체를 다시 생성해서 어플라이 해보자

        vm.books.bind { [weak self] value in
            guard let self else {return}
            print("DEBUG: BIND!")
            var newSnapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, RealmBook>()
            let booksToRead = Array(value).filter { $0.readingStatus == .toRead }
            let booksReading = Array(value).filter { $0.readingStatus == .reading }
            newSnapshot.appendSections([.homeReading,.homeToRead])
            newSnapshot.appendItems(booksToRead,toSection: .homeToRead)
            newSnapshot.appendItems(booksReading,toSection: .homeReading)
            print("DEBUG: Reading",newSnapshot.itemIdentifiers(inSection: .homeReading))
            print("DEBUG:ToRead",newSnapshot.itemIdentifiers(inSection: .homeToRead))
            
            
            dataSource.apply(newSnapshot)
            
            
            
//            self.snapshot.deleteSections([.homeReading,.homeToRead])
//            self.snapshot.appendSections([.homeReading,.homeToRead])
            //forloop 1
//            for book in booksToRead{
//                if self.snapshot.indexOfItem(book) != nil{
//                    self.snapshot.reloadItems([book])
//                } else {
//                    self.snapshot.appendItems([book], toSection: .homeToRead)
//                }
//            }
//            //forloop 2
//            for book in booksReading{
//                if self.snapshot.indexOfItem(book) != nil{
//                    self.snapshot.reloadItems([book])
//                } else {
//                    self.snapshot.appendItems([book], toSection: .homeReading)
//                }
//            }
//            dataSource.apply(snapshot)
        }
        
        
//        vm.booksReading.bind { [weak self] value in
//            print("DEBUG: 1")
//            guard let self = self else { return }
//            let booksReadingArray = Array(value)
//            //clear all before updating? 여기서 어떻게 렘에 바뀐 값만 뺄 수 있을까? 제일 쉬운 방법은 없애고 다시 추가하는것
//            self.snapshot.deleteSections([.homeReading])
//            snapshot.appendSections([.homeReading])
//
//            for book in booksReadingArray{
//                if self.snapshot.indexOfItem(book) != nil{
//                    self.snapshot.reloadItems([book])
//                } else {
//                    self.snapshot.appendItems([book], toSection: .homeReading)
//                }
//            }
////            self.snapshot.appendItems(tempBook, toSection: .homeReading)
//            print("DEBUG: HomeViewController - bindData() - homeReading: number of items in snapshot:",snapshot.numberOfItems(inSection: .homeReading))
//            dataSource.apply(snapshot)
//        }
//
//        vm.booksToRead.bind { [weak self] value in
//            print("DEBUG: 2")
//            guard let self = self else { return }
//            let booksToReadArray = Array(value)
//            self.snapshot.deleteSections([.homeToRead])
//            snapshot.appendSections([.homeToRead])
//
//            for book in booksToReadArray{
//                if self.snapshot.indexOfItem(book) != nil{
//                    self.snapshot.reloadItems([book])
//                } else {
//                    self.snapshot.appendItems([book], toSection: .homeToRead)
//                }
//            }
//            print("DEBUG: HomeViewController - bindData() - homeToRead: number of items in snapshot:",snapshot.numberOfItems(inSection: .homeToRead))
//            dataSource.apply(snapshot)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBook = dataSource.itemIdentifier(for: indexPath)
        let vc = DetailViewController()
        vc.isbn13Identifier = selectedBook?.isbn ?? ""
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
