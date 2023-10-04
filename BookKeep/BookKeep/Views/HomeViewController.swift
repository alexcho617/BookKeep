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
        
        //Data Source
        //MARK: TODO ⚠️ 셀이 혼용되어 사용되어지고 있음. Snapshot안에 있는 데이터는 정상이나 해당 클로져에서 반영된 itemIdentifier를 보면 변경된 데이터가 아닌 다른 데이터를 참조하고 있음. 따라서 RealBook readingStatus가 변경 되었을때 status가 변경된 책과 맞지 않기 때문에 밑의 switch문에서 원하는 Cell을 사용하지 못하고 있음
        dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, RealmBook>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let status = itemIdentifier.readingStatus
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
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let selectedBook = dataSource.itemIdentifier(for: indexPath)
            let vc = DetailViewController()
            vc.isbn13Identifier = selectedBook?.isbn ?? ""
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
}
