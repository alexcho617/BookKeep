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

protocol DiffableDataSourceDelegate: AnyObject {
    func moveSection(itemToMove: RealmBook,from sourceSection: SectionLayoutKind, to destinationSection: SectionLayoutKind)
}

final class HomeViewController: UIViewController, UICollectionViewDelegate, DiffableDataSourceDelegate {
    
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
        collectionView.register(EmptyCollectionViewCell.self, forCellWithReuseIdentifier: "emptyCell") //reuse 는 안함
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
            cell.book = itemIdentifier
            cell.setView()
            cell.setConstraint()
        }
        
        let toReadCellRegistration = UICollectionView.CellRegistration<ToReadCell, RealmBook> { cell, indexPath, itemIdentifier in
            cell.book = itemIdentifier
            cell.setView()
            cell.setConstraints()
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
        
        
        /*
         MARK: Detail 화면에서 reading으로 변경했을때 closure가 안타고 있는게 문제임 ->Snapshot의 데이터는 바뀌었으나 cellProvider가 안불린다.. 왜 안탈까...? 섹션은 바뀌는데
         Snapshot이 바뀌는건 확인 되었음. 그렇다면 스냅샷이 바뀌었다고해서 cellprovider가 꼭 재호출 되는게 아닌것 같은데 이걸 알아봐야ㅕ할듯
         
         */
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
    //TODO 해결!!: Delegate 사용해서 DetailViewController에서 remove + append 조합으로 써보자
    func moveSection(itemToMove: RealmBook,from sourceSection: SectionLayoutKind, to destinationSection: SectionLayoutKind) {
        print(#function, itemToMove.title, sourceSection, destinationSection)
        snapshot.deleteItems([itemToMove])
        dataSource.apply(snapshot, animatingDifferences: true)
        
        //해결.... 하 ㅋㅋㅋㅋㅋ 이게 된 이유는 한 섹션에 없애고 다시 넣으면 뭔가 아이템이 그대로 있긴 하기 때문에 cell provider가 호출되지 않은것 같음.
        //그런데 삭제 후 어플라이 를 했을땐 사라진걸로 인식하고 그리고 추가 후 바로 다시 어플라이를 하니까 섹션에 새로운게 추가된걸로 확싫히 인식함.
        snapshot.appendItems([itemToMove], toSection: destinationSection) // Add the item to the destination section
        dataSource.apply(snapshot, animatingDifferences: true)

    }
    
    private func bindData() {
        vm.books.bind { [weak self] value in
            guard let self = self else { return }
            print("DEBUG: BIND!")
            
            let booksToRead = Array(value).filter { $0.readingStatus == .toRead }
            let booksReading = Array(value).filter { $0.readingStatus == .reading }
            
            var newSnapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, RealmBook>()
            newSnapshot.appendSections([.homeReading, .homeToRead])
            newSnapshot.appendItems(booksToRead, toSection: .homeToRead)
            newSnapshot.appendItems(booksReading, toSection: .homeReading)
            
            //MARK: sectiondata가 추가될때, 그리고 reusable mechanism에 의해 cell이 재사용 될때는 datasource의 cellProvider 클로져가 호출되어 정상적으로 동작하지만 readingStatus 변경으로는 호출되지 않고있다.
//            DispatchQueue.main.async {
//                // 다른지 확인
//                if !self.snapshot.itemIdentifiers(inSection: .homeReading).elementsEqual(newSnapshot.itemIdentifiers(inSection: .homeReading)) ||
//                    !self.snapshot.itemIdentifiers(inSection: .homeToRead).elementsEqual(newSnapshot.itemIdentifiers(inSection: .homeToRead)) {
//                    self.snapshot = newSnapshot
//                    self.dataSource.apply(self.snapshot, animatingDifferences: true)
//                }
//            }
            dataSource.applySnapshotUsingReloadData(newSnapshot) //강제로 모든 item들을 cellProvider에 넣어버리지만 에니메이션 효과 상실
            
        }
    }
}

//Cell Select
extension HomeViewController{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBook = dataSource.itemIdentifier(for: indexPath)
        let vc = DetailViewController()
        vc.delegate = self
        vc.isbn13Identifier = selectedBook?.isbn ?? ""
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

