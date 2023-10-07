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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    func setView(){
        //TODO: Reading.status 따라 보여주는 화면 다르게해야함. .toRead면 startReadingButton 추가하고 homeVC에서 섹션이동하는것 확인 필요
        navigationItem.rightBarButtonItems = vm.book.value?.readingStatus == .reading ? [menuButton, editButton] : [menuButton]
        tableView.backgroundColor = Design.colorPrimaryBackground
        tableView.delegate = self
        tableView.dataSource = self
        
//        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 700
//        tableView.sectionHeaderHeight = 700
        
        tableView.register(TableHeader.self, forHeaderFooterViewReuseIdentifier: "TableHeader")
        tableView.register(DetailTableHeader.self, forHeaderFooterViewReuseIdentifier: "DetailTableHeader")
        view.addSubview(tableView)
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
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "내가 추가한 메모"
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DetailTableHeader") as? DetailTableHeader else {
            return UIView()
        }
        guard let book = vm.book.value else {
            return UITableViewHeaderFooterView()
        }
        
        // Set data to the header view to calculate its height
        header.setData(book: book)
        
        // Update the constraints of the header view
        header.setNeedsLayout()
        header.layoutIfNeeded()
        
        // Return the header view
        return header
    }


    //⚠️TODO: 헤더 높이를 가변으로 하려는건 intro의 높이와 타이틀의 높이가 가변이기 때문인데 보통은 700을 넘어가지 않는다. 만약 헤더 높이를 가변으로 결국 하지 못한다면 intro의 높이라도 고정시켜야 할것 같다. intro에 textview사용 고려.
//        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DetailTableHeader") as? DetailTableHeader else {
//                return UIView()
//            }
//            guard let book = vm.book.value else {return UITableViewHeaderFooterView()}
//            header.setData(book: book)
//            return header
//        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20 //TODO: vm.memos.count 같은걸로 구현
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
