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

class TableDetailViewController: UIViewController {
    var isbn13Identifier: String = ""
    private lazy var vm = DetailViewModel(isbn: isbn13Identifier)
    weak var delegate: DiffableDataSourceDelegate? //section 이동
    
    //views
    let views = DetailViewComponents()
    var tableView = UITableView()
    
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
        setConstratins()
        bindView()

    }
    func setView(){
        view.addSubview(tableView)
        navigationItem.rightBarButtonItems = vm.book.value?.readingStatus == .reading ? [menuButton, editButton] : [menuButton]

        tableView.backgroundColor = Design.debugBlue
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(DetailTableHeader.self, forHeaderFooterViewReuseIdentifier: "DetailTableHeader")
    }
    func setConstratins(){
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bindView(){
        vm.book.bind { book in
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

extension TableDetailViewController: UITableViewDelegate, UITableViewDataSource{
    
   
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 800
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DetailTableHeader") as? DetailTableHeader else {
            return UIView()
        }
        guard let book = vm.book.value else {return UITableViewHeaderFooterView()}
        header.setData(book: book)
        return header
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 //TODO: vm.memos.count 같은걸로 구현
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //create memocell
        let cell = UITableViewCell()
        cell.textLabel?.text = indexPath.description
        return cell
        
    }
    
    
}

//MARK: functions
extension TableDetailViewController{
    
    @objc func readBook(){
//        print(#function)
        guard let book = vm.book.value else {return}
        if book.readingStatus == .toRead{
            vm.startReading {
//                self.startReadingButton.isHidden = true
                
            }
//            print("DEBUG: Detail Delegate: Move Section")
            delegate?.moveSection(itemToMove: book, from: .homeToRead, to: .homeReading)
        }
        
    }
    
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
        let vc = EditViewController()
        vc.isbn = isbn13Identifier
        if let sheet = vc.sheetPresentationController{
            sheet.detents = [.medium()]
        }
        present(vc, animated: true, completion: nil)
    }
    
    private func confirmDelete(title: String?, message: String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
            //closure
            self.vm.deleteBookFromRealm {
                self.navigationController?.popViewController(animated: true)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert,animated: true)
    }
}
