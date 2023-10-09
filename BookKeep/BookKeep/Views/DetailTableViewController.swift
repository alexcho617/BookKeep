//
//  TableDetailViewController.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/06.
//

import UIKit
import SnapKit
import RealmSwift
import Kingfisher

enum DetailCellType: Int{
    case MemoCell
}

class DetailTableViewController: UIViewController {
    var vm: DetailViewModel?
    weak var delegate: DiffableDataSourceDelegate? //section 이동
    
    //views
    let views = DetailViewComponents()
    var tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    lazy var menuButton: UIBarButtonItem = {
        let view = UIBarButtonItem(title: "메뉴", style: .plain, target: self, action: #selector(showMenu))
        view.image = UIImage(systemName: "ellipsis")
        return view
    }()
    
    lazy var editButton: UIBarButtonItem = {
        let view = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(showEdit))
        view.image = UIImage(systemName: "pencil")
        return view
    }()
    
    //vdl
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        bindView()
        
    }
    
    func setView(){
        navigationItem.rightBarButtonItems = vm?.book.value?.readingStatus == .reading ? [menuButton, editButton] : [menuButton]
        tableView.backgroundColor = Design.colorPrimaryBackground
        tableView.delegate = self
        tableView.dataSource = self

        tableView.estimatedSectionHeaderHeight = 700 //placeholder
        
        tableView.register(DetailTableHeader.self, forHeaderFooterViewReuseIdentifier: "DetailTableHeader")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    
    func bindView(){
        vm?.book.bind { book in
            self.setView()
            self.tableView.reloadData()
        }
    }
    
    @objc func showMenu(){
        showActionSheet(title: nil, message: nil)
    }
    
    @objc func showEdit(){
        showEditSheet()
    }
    
}

extension DetailTableViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let book = vm?.book.value else {return nil}
        let status = book.readingStatus
        switch status {
        case .reading:
            if book.memos.count != 0{
                return Literal.memoSectionTitle
            }else{
                return Literal.noMemoSectionTitle
            }
        case .toRead,.done,.paused,.stopped:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DetailTableHeader") as? DetailTableHeader else {
            return UIView()
        }
        guard let book = vm?.book.value else {
            return UITableViewHeaderFooterView()
        }
        header.detailBook = book
        header.vm = vm
        header.setViews()
        header.setData()
        
        // Update the constraints of the header view
        DispatchQueue.main.async {
            header.setNeedsLayout()
            header.layoutIfNeeded()
        }

        // Return the header view
        return header
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm?.book.value?.memos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //create memocell
        let cell = UITableViewCell()
        cell.textLabel?.text = indexPath.description
        return cell
        
    }
    
    
}

//MARK: functions
extension DetailTableViewController{
    
    private func showActionSheet(title: String?, message: String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "책 삭제", style: .destructive) { _ in
            self.confirmDelete(title: "주의", message: "삭제된 데이터는 복구되지 않습니다")
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert,animated: true)
    }
    
    private func showEditSheet(){
        guard let isbn = vm?.book.value?.isbn else {return}
        let vc = EditViewController()
        vc.isbn = isbn
        if let sheet = vc.sheetPresentationController{
            sheet.detents = [.medium()]
        }
        present(vc, animated: true, completion: nil)
    }
    
    private func confirmDelete(title: String?, message: String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
            //closure
            self.vm?.deleteBookFromRealm {
                self.navigationController?.popViewController(animated: true)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert,animated: true)
    }
}
