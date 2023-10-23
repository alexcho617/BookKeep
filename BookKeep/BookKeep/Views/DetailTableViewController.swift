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
import Toast

protocol DetailViewDelegate: AnyObject {
    func reloadTableView()
    func popToRootView()
    func showToast(title: String)
}

class DetailTableViewController: UIViewController{
    var vm: DetailViewModel?
    
    //views
    let views = DetailViewComponents()
    var tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    lazy var menuButton: UIBarButtonItem = {
        let view = UIBarButtonItem(title: "메뉴", style: .plain, target: self, action: #selector(showMenuClicked))
        view.image = UIImage(systemName: "ellipsis")
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
        navigationItem.rightBarButtonItems = [menuButton]
        tabBarController?.tabBar.isHidden = true
        tableView.backgroundColor = Design.colorPrimaryBackground
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(DetailTableHeader.self, forHeaderFooterViewReuseIdentifier: "DetailTableHeader")
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.identifier)
        tableView.register(DetailTableViewSessionCell.self, forCellReuseIdentifier: DetailTableViewSessionCell.identifier)
        tableView.register(DetailTableFooter.self, forHeaderFooterViewReuseIdentifier: "DetailTableFooter")

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
    
    @objc func showMenuClicked(){
        showActionSheet(title: nil, message: nil)
    }
    
}

extension DetailTableViewController: DetailViewDelegate{
    func showToast(title: String) {
        let toast = Toast.text(title)
        toast.show(haptic: .success)
    }
    func reloadTableView() {
//        print("DetailTableViewController-",#function)
        tableView.reloadData()
    }
    func popToRootView(){
        navigationController?.popToRootViewController(animated: true)
    }

}

extension DetailTableViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        print(#function, section)
        guard let book = vm?.book.value else {return nil}
        //메모 섹션
        if section == 0{
            if book.memos.count != 0{
                return Literal.memoSectionTitle
            }else{
                return Literal.noMemoSectionTitle
            }
        //독서 섹션
        }
        if section == 1{
            if book.readSessions.count != 0{
                return Literal.sessionSectionTitle
            }else{
                return Literal.noSessionSectionTitle
            }
        }
        return nil
    }

    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //맨 위에만 헤더 추가
        if section == 0{
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DetailTableHeader") as? DetailTableHeader else {
                return UIView()
            }
            guard let book = vm?.book.value else {
                return UITableViewHeaderFooterView()
            }
            header.detailBook = book
            header.vm = vm
            header.memoButtonAction = {
                let vc = MemoViewController()
                vc.vm = self.vm
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            header.readButtonAction = {
                let vc = ReadingViewController()
                vc.isbn = book.isbn
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            header.setViews()
            header.setData()
            
            // Update the constraints of the header view
            DispatchQueue.main.async {
                header.setNeedsLayout()
                header.layoutIfNeeded()
            }
            
            // Return the header view
            return header
            
        //독서기록섹션인 경우
        }else{
            return nil //시스템 헤더 자동 추가
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        //맨 아래만 푸터 추가
        guard section == 1 else {return UIView()}
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DetailTableFooter") as? DetailTableFooter else {
            return UIView()
        }
        return footer
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var section = 0
        if vm?.book.value?.readSessions.count == 0{
            section = 1
        }else{
            section = 2
        }
//        print(#function, section)
        return section
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return vm?.book.value?.memos.count ?? 1
        }else if section == 1{
            return vm?.book.value?.readSessions.count ?? 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            //create memocell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier) as? DetailTableViewCell else {return UITableViewCell() }
            guard let memoRow = vm?.sortedMemos[indexPath.row] else {return UITableViewCell()}
            cell.memo = memoRow
            cell.setView()
            return cell
        }else if indexPath.section == 1{
            //create read session cell
            guard let sessionRow = vm?.sortedReadSessions[indexPath.row] else {return UITableViewCell()}
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewSessionCell.identifier) as? DetailTableViewSessionCell else {return UITableViewCell()}
            cell.isUserInteractionEnabled = false
            cell.session = sessionRow
            cell.setView()
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //메모만 가능
        guard indexPath.section == 0 else {return UISwipeActionsConfiguration()}
        let delete = UIContextualAction(style: .destructive, title: "삭제"){ [weak self] _,_,_ in
            self?.confirmDeleteMemo(title: "경고", message: "정말 메모를 삭제하시겠습니까?", memo: self?.vm?.book.value?.memos[indexPath.row])
        }
        delete.image = UIImage(systemName: "trash")
        let config = UISwipeActionsConfiguration(actions: [delete])
        return config
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 0 else {return}
        guard let memoRow = vm?.book.value?.memos[indexPath.row] else {return }

        let vc = MemoViewController()
        vc.selectedMemo = memoRow
        vc.vm = vm
        vc.detailDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


//MARK: functions
extension DetailTableViewController{
    private func showActionSheet(title: String?, message: String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "책 삭제", style: .destructive) { _ in
            self.confirmDelete(title: "경고", message: "정말 책을 삭제하시겠습니까?")
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let editPage = UIAlertAction(title: "페이지 수정", style: .default) {_ in
            self.showEditSheet()
        }
        
        let editStatus = UIAlertAction(title: "상태 수정", style: .default){_ in
            self.showStatusSheet()
        }
        
        if vm?.book.value?.readingStatus == .done{
            let readAgain = UIAlertAction(title: "책 다시읽기", style: .default) { _ in
                self.readAgain()
            }
            alert.addAction(readAgain)
        }
        alert.addAction(editStatus)
        alert.addAction(editPage)
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert,animated: true)
    }
    
 
    private func showEditSheet(){
        guard let isbn = vm?.book.value?.isbn else {return}
        let vc = EditViewController()
        vc.isbn = isbn
        vc.detailDelegate = self
        if let sheet = vc.sheetPresentationController{
            sheet.detents = [.medium()]
        }
        present(vc, animated: true, completion: nil)
    }
    
    func showStatusSheet(){
        guard let isbn = vm?.book.value?.isbn else {return}
        let alert = UIAlertController(title: "책 상태 수정", message: nil, preferredStyle: .actionSheet)
        
        let done = UIAlertAction(title: "읽은 책", style: .default){_ in
            if self.vm?.book.value?.readingStatus != .done{
                BooksRepository.shared.updateBookReadingStatus(isbn: isbn, to: .done)
                self.navigationController?.popToRootViewController(animated: true)
            }
            
        }
        let reading = UIAlertAction(title: "읽고 있는 책", style: .default){_ in
            if self.vm?.book.value?.readingStatus != .reading{
                BooksRepository.shared.updateBookReadingStatus(isbn: isbn, to: .reading)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        let toRead = UIAlertAction(title: "읽을 예정인 책", style: .default){_ in
            if self.vm?.book.value?.readingStatus != .toRead{
                BooksRepository.shared.updateBookReadingStatus(isbn: isbn, to: .toRead)
                self.navigationController?.popToRootViewController(animated: true)

            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(done)
        alert.addAction(reading)
        alert.addAction(toRead)
        alert.addAction(cancel)
        present(alert,animated: true)
    }
    
    private func confirmDeleteMemo(title: String?, message: String?, memo: Memo?){
//        print(#function, memo)
        guard let memo = memo else { return }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
            //closure
            self.vm?.deleteMemo(memo)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert,animated: true)
    }
    
    //TODO: 업적-> 상세화면에서 다시 읽은 경우 startReading버튼이 잠깐 떠버린다. 안뜨고 화면을 없에던가 아니면 뷰를 바꾸던가 해야할듯
    private func readAgain(){
        let alert = UIAlertController(title: "다시 읽기", message: "책을 한번 더 읽으시겠습니까?", preferredStyle: .alert)
        let read = UIAlertAction(title: "읽기", style: .default) { _ in
            self.vm?.startReading(isAgain: true){
                let toast = Toast.text("읽을 예정인 책에 추가되었습니다")
                toast.show(haptic: .success)
                self.navigationController?.popViewController(animated: true)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(read)
        alert.addAction(cancel)
        present(alert,animated: true)
    }
    
    private func confirmDelete(title: String?, message: String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
            //closure
            self.vm?.deleteBookFromRealm() {
                self.navigationController?.popViewController(animated: true)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert,animated: true)
    }
}
