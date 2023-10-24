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
    func reloadCollectionView()
}

final class HomeViewController: UIViewController, UICollectionViewDelegate, DiffableDataSourceDelegate {
    
    //Variables
    let vm = HomeViewModel()
    var booksToRead: [RealmBook] = []
    var booksReading: [RealmBook] = []
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
        if UserDefaults.standard.object(forKey: UserDefaultsKey.LastReadingState.rawValue) != nil{
            print("DEBUG: 저장되지 않은 세션 있음")
            //복구 정보
            guard let isbn = UserDefaults.standard.object(forKey: UserDefaultsKey.LastISBN.rawValue) as? String else {return}
            guard let startTime = UserDefaults.standard.object(forKey: UserDefaultsKey.LastStartTime.rawValue) as? Date else {return}
            guard let readTime = UserDefaults.standard.object(forKey: UserDefaultsKey.LastElapsedTime.rawValue) as? TimeInterval else {return}
            
            HomeViewController.printUserDefaultsStatus()
            self.showActionAlert(title: "독서 기록 복구", message: "저장하지 않은 독서기록을 불러오시겠습니까?") {
                //alert action present ReadCompleteVC
                let vc = ReadCompleteViewController()
                vc.isbn = isbn
                vc.startTime = startTime
                vc.readTime = readTime
                vc.navigationHandler = {
                    self.reloadCollectionView()
                }
                if let sheet = vc.sheetPresentationController{
                    sheet.detents = [.medium(), .large()]
                    sheet.prefersGrabberVisible = true
                }
                self.present(vc, animated: true, completion: nil)
                
            }
            
        } else{
            print("DEBUG: 저장되지 않은 세션 없음")
        }
        BooksRepository.shared.realmURL()
        
    }

    private func configureHierarchy(){
        baseView = addBaseView()
        view.addSubview(baseView)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayoutBySection())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        collectionView.delegate = self
        //TODO: empty cell 적용
        collectionView.register(EmptyCollectionViewCell.self, forCellWithReuseIdentifier: "emptyCell") //reuse 는 안함
        snapshot.appendSections([.homeReading,.homeToRead])
        
    }
    
    private func setConstraints(){
        baseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setViewDesign(){
        collectionView.backgroundColor = .clear
        title = "홈"
        let appearance = UINavigationBarAppearance()
        appearance.shadowImage = UIImage()
        appearance.backgroundImage = UIImage()
        appearance.backgroundColor = Design.colorPrimaryAccent
        navigationController?.navigationBar.tintColor = Design.colorPrimaryBackground
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
    }
    
    private func showActionAlert(title: String, message: String, handler: (()->Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "버리기", style: .destructive) { _ in
            self.clearUD()
        }
        let confirmAction = UIAlertAction(title: "불러오기", style: .default) { _ in
            handler?()
        }
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert,animated: true)
    }
    
    private func clearUD(){
        print("DEBUG: UD will Clear")
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.LastReadingState.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.LastElapsedTime.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.LastISBN.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.LastStartTime.rawValue)
        print("DEBUG: UD is Cleared")
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
        
        let groupFractionalWidth = 1.0
        let groupFractionalHeight = 0.4
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(CGFloat(groupFractionalWidth)),
            heightDimension: .fractionalHeight(groupFractionalHeight))

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
            supplementaryView.welcomeLabel.text = Literal.mainGreeting
            //MARK: 책 갯수를 넣어주려고 하였으나 snapshot reload 문제로 추후 업데이트
//            supplementaryView.welcomeLabel.text = Literal.mainGreeting + " (\(self.booksReading.count))"

        }
        
        let toReadHeaderRegistration = UICollectionView.SupplementaryRegistration<ToReadSectionHeaderView>(elementKind: SectionSupplementaryKind.toReadHeader.rawValue) { supplementaryView, elementKind, indexPath in
            //여기서 cell 처럼 header view 코드 실행 가능
            supplementaryView.title.text = Literal.secondSectionLabel
//            supplementaryView.title.text = Literal.secondSectionLabel + " (\(self.booksToRead.count))"
        }
        
        dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, RealmBook>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            //MARK: 책 갯수를 넣어주려고 하였으나 reload 문제로 추후 업데이트
//            print("DEBUG: Cell Provider", itemIdentifier.title, itemIdentifier.readingStatus)
            
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
    
    /*
     MARK: 아이템을 A->B섹션 동시킬 때는 삭제 후 Apply 후 Append후 다시 Apply를 하여 Snapshot이 달라진것을 더 명확히 한다. 이렇게 할 경우 cellProvider가 다시 호출되는것을 확인했다.
     */
    func moveSection(itemToMove: RealmBook,from sourceSection: SectionLayoutKind, to destinationSection: SectionLayoutKind) {
//        print(#function, itemToMove.title, sourceSection, destinationSection)
        snapshot.deleteItems([itemToMove])
        dataSource.apply(snapshot, animatingDifferences: true)
        
        snapshot.appendItems([itemToMove], toSection: destinationSection) // Add the item to the destination section
        dataSource.apply(snapshot, animatingDifferences: true)

    }
    
    func reloadCollectionView(){
        //호출은 되는데 변경이 없네
        print("HomeViewController-",#function)
//        snapshot.reloadSections([section])
        collectionView.reloadData() //비효율적이지만 일단 이렇게 하고 넘어가자.
    }
    
    
    private func bindData() {
        vm.books.bind { [weak self] value in
            guard let self = self else { return }
            print("DEBUG: BIND Data")
            booksToRead = Array(value).filter { $0.readingStatus == .toRead }
            booksReading = Array(value).filter { $0.readingStatus == .reading }
            var newSnapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, RealmBook>()
            newSnapshot.appendSections([.homeReading, .homeToRead])
            newSnapshot.appendItems(booksToRead, toSection: .homeToRead)
            newSnapshot.appendItems(booksReading, toSection: .homeReading)
            dataSource.apply(newSnapshot, animatingDifferences: true)
        }
        
    }
}

//Cell Select
extension HomeViewController{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedBook = dataSource.itemIdentifier(for: indexPath) else {return}
        let vc = DetailTableViewController()
        vc.vm = DetailViewModel(isbn: selectedBook.isbn)
        vc.vm?.homeDelegate = self
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

