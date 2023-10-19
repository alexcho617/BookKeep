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
    let activityIndicator = UIActivityIndicatorView(style: .large)
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
        view.addSubview(activityIndicator)


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
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(4*Design.paddingDefault)
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
        activityIndicator.color = UIColor.label
        searchBar.becomeFirstResponder()
    }
   
    private func bindData(){
        vm.searchResult.bind { result in
            self.collectionView.reloadData()
        }
    }
    
    deinit {
        print("SearchViewController deinit")
    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Start the activity indicator animation
        activityIndicator.startAnimating()

        // Set the error handler closure
        vm.errorHandler = { [weak self] in
            // Stop the activity indicator animation
            self?.activityIndicator.stopAnimating()

            // Show an alert indicating a network error
            self?.showAlert(title: "에러", message: "네트워크 환경이 좋지 못합니다") {
                self?.dismiss(animated: true)
            }
        }

        searchBar.resignFirstResponder()

        // Start the searchBook function with a completion handler
        vm.searchBook(query: searchBar.text) { [weak self] in
            // Stop the activity indicator animation after the search is complete
            self?.activityIndicator.stopAnimating()

            if let items = self?.vm.searchResult.value?.item, !items.isEmpty {
                self?.collectionView.scrollToItem(at: IndexPath(item: -1, section: 0), at: .top, animated: true)
            } else {
                // The items array is either nil or empty
                self?.showAlert(title: "에러", message: "검색 결과가 없습니다", handler: nil)
                searchBar.text = nil
            }
        }
    }
}


//⚠️TODO: DataSourcePrefetching
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
        let vc = SearchDetailViewController()
        vc.isbn13Identifier = vm.searchResult.value?.item[indexPath.item].isbn13 ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
   
    
}
