//
//  ViewController.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/25.
//

import UIKit
import SnapKit
import Kingfisher

final class HomeViewController: UIViewController, UICollectionViewDelegate {
    enum SectionLayoutKind: Int, CaseIterable{
        case single, double
        var columnCount: Int{
            switch self{
            case .single:
                return 1
            case .double:
                return 2
            }
        }
    }
    
    //Variables
    let vm = HomeViewModel()
    var dataSource: UICollectionViewDiffableDataSource<SectionLayoutKind, RealmBook>!
    //Views
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureHierarchy()
        setConstraints()
        configureDataSource()
    }
    func configureHierarchy(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayoutBySection())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    func setConstraints(){
        
    }
    
    func configureDataSource(){
        //Cell 등록
        let readingCellRegistration = UICollectionView.CellRegistration<ReadingCell, RealmBook> { cell, indexPath, itemIdentifier in
            cell.label.text = itemIdentifier.title
            cell.imageView.kf.setImage(with: URL(string: MockData.sampleImage))
            cell.backgroundColor = .gray
        }
        
        let toReadCellRegistration = UICollectionView.CellRegistration<ToReadCell, RealmBook> { cell, indexPath, itemIdentifier in
            cell.label.text = itemIdentifier.title
            cell.backgroundColor = .systemMint
        }
        //DS
        dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, RealmBook>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let sectionType = SectionLayoutKind(rawValue: indexPath.section)
            switch sectionType{
            case .single:
                return collectionView.dequeueConfiguredReusableCell(using: readingCellRegistration, for: indexPath, item: itemIdentifier)
            case .double:
                return collectionView.dequeueConfiguredReusableCell(using: toReadCellRegistration, for: indexPath, item: itemIdentifier)
            case .none:
                return UICollectionViewCell()
            }
        })
        
        //apply snapshot
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, RealmBook>()
        snapshot.appendSections([.single, .double])
        snapshot.appendItems(vm.booksReading,toSection: .single)
        snapshot.appendItems(vm.bookstoRead,toSection: .double)
        dataSource.apply(snapshot)
    }
    
    func generateLayoutBySection() -> UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let sectionKind = SectionLayoutKind(rawValue: sectionIndex)
            switch sectionKind{
            case .single: return self.createBooksReadingLayout()
            case .double: return self.createBooksToReadLayout()
            case .none:
                return self.createBooksReadingLayout()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        layout.configuration = config
        return layout
    }
    
    //가로 스크롤, 셀 하나씩 보여주는 섹션
    func createBooksReadingLayout() -> NSCollectionLayoutSection{
        
        //Mine
        //        let itemSize = NSCollectionLayoutSize(
        //            widthDimension: .fractionalWidth(1.0),
        //            heightDimension: .fractionalWidth(2/3))
        //        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        //
        //        let groupSize = NSCollectionLayoutSize(
        //            widthDimension: .fractionalWidth(1.0),
        //            heightDimension: .fractionalWidth(2/3))
        //
        //        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        
        
        //Kodeco
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(2/3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupFractionalWidth = 0.95
        let groupFractionalHeight: Float = 2/3
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
        
        return section
    }
    
    //세로 스크롤, 셀 두개씩 보여주는 섹션
    func createBooksToReadLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
}

