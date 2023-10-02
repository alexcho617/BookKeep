//
//  SearchViewController.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/29.
//

import UIKit

class SearchViewController: UIViewController{
    let vm = SearchViewModel()
    var baseView: UIStackView!
    let searchBar = UISearchBar()
    var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: SearchViewController.getCollectionViewLayout())
        return view
    }()
    static func getCollectionViewLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 150)
        return layout
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        setConstraints()
        setViewDesign()
        bindData()
    }
    override func viewDidDisappear(_ animated: Bool) {
        print(#function)
    }
    private func configureHierarchy(){
        baseView = addBaseView()
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        collectionView.keyboardDismissMode = .onDrag
        
        view.addSubview(baseView)
        view.addSubview(searchBar)
        view.addSubview(collectionView)
    }
  
    private func setConstraints(){
        baseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(Design.paddingDefault)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setViewDesign(){
        collectionView.backgroundColor = .clear
        title = "책 검색하기"
       
    }
    
    private func bindData(){
        vm.searchResult.bind { result in
//            print("DEBUG: SearchViewController-bindData(): 데이터 변경 감지")
            self.collectionView.reloadData()
        }
    }
    
    deinit {
        print("SearchViewController deinit")
    }

}

extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        vm.searchBook(query: searchBar.text)
    }
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.searchResult.value?.item.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        let row = vm.searchResult.value?.item[indexPath.item]
        cell.item = row
        cell.setView()
        cell.setConstraints()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("DEBUG:",#function)
        let vc = SearchDetailViewController()
        vc.isbn13Identifier = vm.searchResult.value?.item[indexPath.item].isbn13 ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
   
    
}
