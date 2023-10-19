//
//  SettingsViewController.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/19.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    let vm = SettingsViewModel()
    let tableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.backgroundColor = Design.colorPrimaryBackground
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraints()
    }
    func setView(){
        view.backgroundColor = Design.colorPrimaryAccent
        let appearance = UINavigationBarAppearance()
        appearance.shadowImage = UIImage()
        appearance.backgroundImage = UIImage()
        appearance.backgroundColor = Design.colorPrimaryAccent
        navigationController?.navigationBar.tintColor = Design.colorPrimaryBackground
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        title = "세팅"
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func setConstraints(){
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
}


extension SettingsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.items[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return vm.sections[section]
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        
        let item = vm.items[indexPath.section][indexPath.row]
        let itemKind = Items(rawValue: item)
        switch itemKind {
        case .infoPolicy:
            print("Info")
        case .sendEmail:
            print("email")
        case .appVersion:
            cell.textLabel?.text = item + vm.currentVersion
        case .none:
            print("None")
        }
        cell.textLabel?.text = item
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

