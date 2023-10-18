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
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: getCollectionViewLayout())
        return view
    }()
    
    func getCollectionViewLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 150)
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        bindData()
        setConstraints()
        setViewDesign()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        print(#function)
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
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Design.colorPrimaryAccent
        let buttonAppearance = UIBarButtonItemAppearance()
        appearance.buttonAppearance = buttonAppearance
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = Design.colorPrimaryBackground
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        title = "검색하기"
        searchBar.becomeFirstResponder()
    }
   
    private func bindData(){
        //TODO: 검색하는동안 Progress Indicator 추가
        vm.searchResult.bind { result in
            self.collectionView.reloadData()
        }
    }
    
    deinit {
        print("SearchViewController deinit")
    }

}

extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //TODO: start indicator
        vm.searchBook(query: searchBar.text){ [self] in
            if vm.searchResult.value?.item.count != 0{
                //TODO: end indicator
                collectionView.scrollToItem(at: IndexPath(item: -1, section: 0), at: .top, animated: true)
            }
        }
        
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
        //TODO: item 정보 없는 경우 에러처리 노션 참고. Ex, 해리포터 세트 선택
        let vc = SearchDetailViewController()
        vc.isbn13Identifier = vm.searchResult.value?.item[indexPath.item].isbn13 ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
   
    
}
