//
//  SearchViewController.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/29.
//

import UIKit

class SearchViewController: UIViewController{
    
    var baseView: UIStackView!
    let vm = SearchViewModel()
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        setConstraints()
        setViewDesign()
        bindData()
    }
    
    private func configureHierarchy(){
        baseView = addBaseView()
        searchBar.delegate = self
        view.addSubview(baseView)
        view.addSubview(searchBar)
    }
    
    private func setConstraints(){
        baseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
     
    }
    private func setViewDesign(){
        
    }
    
    private func bindData(){
//        vm.list.bind { <#[RealmBook]#> in
//            <#code#>
//        }
    }
    
    deinit {
        print("SearchViewController deinit")
    }

}

extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Key:",searchBar.text)
        vm.searchBook(query: searchBar.text)
    }
    
}
