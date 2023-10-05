//
//  DetailViewController.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/02.
//

import UIKit
import SnapKit
import Kingfisher
import RealmSwift

final class DetailViewController: UIViewController {
    var isbn13Identifier: String = ""
    private lazy var vm = DetailViewModel(isbn: isbn13Identifier)
    weak var delegate: DiffableDataSourceDelegate?

    
    private let bookTitle = {
        let view = UILabel()
        view.textColor = Design.colorTextSubTitle
        view.font = Design.fontSubTitle
        view.text = "제목"
        view.numberOfLines = 0
        return view
    }()
    
    private let coverImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.borderColor = Design.colorPrimaryAccent?.cgColor
        view.layer.borderWidth = 2
        
        view.layer.cornerRadius = Design.paddingDefault
        view.clipsToBounds = true
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.layer.shadowOpacity = 0.5
        return view
    }()
    
    private let author = {
        let view = UILabel()
        view.text = "저자"
        view.font = Design.fontDefault
        view.textColor = Design.colorTextDefault
        view.numberOfLines = 0
        return view
    }()
    
    private let introduction = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = ""
        view.font = Design.fontDefault
        view.textColor = Design.colorTextDefault
        return view
    }()
    
    private let publisher = {
        let view = UILabel()
        view.text = "출판사"
        view.font = Design.fontDefault
        view.textColor = Design.colorTextDefault
        return view
    }()
    
    private let isbn = {
        let view = UILabel()
        view.text = "ISBN"
        view.font = Design.fontDefault
        view.textColor = Design.colorTextDefault
        return view
    }()
    
    private let page = {
        let view = UILabel()
        view.text = "페이지"
        view.font = Design.fontDefault
        view.textColor = Design.colorTextDefault
        return view
    }()
    
    lazy var infoStack = {
        let view = UIStackView(arrangedSubviews: [LabelViews.introductionLabel,introduction,LabelViews.publisherLabel,publisher, LabelViews.isbnLabel,isbn])
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = 4
        return view
    }()
    
    var readButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "timer"), for: .normal)
        button.backgroundColor = Design.colorPrimaryAccent
        button.tintColor = Design.colorSecondaryAccent
        button.layer.cornerRadius = Design.paddingDefault
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    var memoButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "note.text.badge.plus"), for: .normal)
        button.backgroundColor = Design.colorPrimaryAccent
        button.tintColor = Design.colorSecondaryAccent
        button.layer.cornerRadius = Design.paddingDefault
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    private var startReadingButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "book"), for: .normal)
        button.setTitle(Literal.startReadingLabel, for: .normal)
        button.backgroundColor = Design.colorPrimaryAccent
        button.tintColor = Design.colorSecondaryAccent
        button.setTitleColor(Design.colorSecondaryAccent, for: .normal)
        button.layer.cornerRadius = Design.paddingDefault
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    private lazy var menuButton: UIBarButtonItem = {
        let view = UIBarButtonItem(title: "메뉴", style: .plain, target: self, action: #selector(showMenu))
        view.image = UIImage(systemName: "ellipsis")
        return view
    }()
    
    private lazy var editButton: UIBarButtonItem = {
        let view = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(showEdit))
        view.image = UIImage(systemName: "pencil")
        return view
    }()
    
    //TODO: Edit SheetView
    lazy var scrollView = {
        let view = UIScrollView()
        view.delegate = self
        return view
    }()
    
    lazy var baseView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewHierarchy()
        setViewDesign()
        setConstraints()
        bindData()
    }
    
    func setViewHierarchy(){
        //get data from realm
        guard vm.book.value != nil else {
            showAlert(title: "에러", message: "데이터베이스에서 책을 가져오는데 실패했습니다.") {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        navigationItem.rightBarButtonItems = [menuButton, editButton]
        view.addSubview(scrollView)
        scrollView.addSubview(baseView)
        baseView.addSubview(bookTitle)
        baseView.addSubview(coverImageView)
        baseView.addSubview(author)
        baseView.addSubview(readButton)
        baseView.addSubview(memoButton)
        
        
        if vm.book.value?.readingStatus == .reading{
            
            baseView.addSubview(LabelViews.pageLabel)
            baseView.addSubview(page)
            //info stack
            baseView.addSubview(infoStack)
        }
        
        if vm.book.value?.readingStatus == .toRead{
            baseView.addSubview(startReadingButton)
            startReadingButton.addTarget(self, action: #selector(readBook), for: .touchUpInside)
        }
        
        
    }
    
    func setViewDesign(){
        view.backgroundColor = Design.colorPrimaryBackground
    }
    
    func setConstraints(){
        ///MARK: Scroll + Base views
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        baseView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide).inset(Design.paddingDefault)
            make.width.equalTo(scrollView.snp.width).inset(Design.paddingDefault)
            make.height.greaterThanOrEqualTo(view.snp.height).priority(.low)
        }
        
        ///MARK: Upper Layout
        bookTitle.snp.makeConstraints { make in
            make.top.width.equalTo(baseView)
        }
        
        coverImageView.snp.makeConstraints { make in
            make.top.equalTo(bookTitle.snp.bottom).offset(2*Design.paddingDefault)
            make.leading.equalTo(bookTitle)
            make.width.equalTo(baseView.snp.width).multipliedBy(0.4)
            make.height.equalTo(coverImageView.snp.width).multipliedBy(1.5)
        }
        
        author.snp.makeConstraints { make in
            make.top.equalTo(coverImageView)
            make.leading.equalTo(coverImageView.snp.trailing).offset(Design.paddingDefault)
            make.width.equalTo(baseView.snp.width).multipliedBy(0.55)
        }
        
        readButton.snp.makeConstraints { make in
            make.bottom.equalTo(coverImageView)
            make.leading.equalTo(coverImageView.snp.trailing).offset(2*Design.paddingDefault)
            make.width.equalTo(baseView.snp.width).multipliedBy(0.15)
            make.height.greaterThanOrEqualTo(32)
        }
        
        memoButton.snp.makeConstraints { make in
            make.bottom.equalTo(readButton)
            make.leading.equalTo(readButton.snp.trailing).offset(Design.paddingDefault)
            make.width.equalTo(baseView.snp.width).multipliedBy(0.15)
            make.height.greaterThanOrEqualTo(32)
        }

        ///MARK: Lower
        if vm.book.value?.readingStatus == .reading{
            //page
            LabelViews.pageLabel.snp.makeConstraints { make in
                make.leading.equalTo(coverImageView)
                if vm.book.value?.readingStatus == .toRead{
                    make.top.equalTo(startReadingButton.snp.bottom).offset(Design.paddingDefault)
                }else{
                    make.top.equalTo(coverImageView.snp.bottom).offset(Design.paddingDefault)
                }
                
                
            }
            page.snp.makeConstraints { make in
                make.leading.equalTo(coverImageView)
                make.top.equalTo(LabelViews.pageLabel.snp.bottom).offset(Design.paddingDefault)
            }
            
            //stackview
            infoStack.snp.makeConstraints { make in
                make.top.equalTo(page.snp.bottom).offset(Design.paddingDefault)
                make.width.equalTo(baseView)
            }
        }
        
        if vm.book.value?.readingStatus == .toRead{
            startReadingButton.snp.makeConstraints { make in
                make.top.equalTo(coverImageView.snp.bottom).offset(Design.paddingDefault)
                make.width.equalTo(baseView.snp.width).inset(Design.paddingDefault)
                make.height.greaterThanOrEqualTo(32)
            }
        }
    }
    
    @objc func showMenu(){
        showActionSheet(title: nil, message: nil)
    }
    
    @objc func showEdit(){
       showEditSheet()
    }
    func bindData(){
        vm.book.bind { [self] selectedBook in
            //update UI
            setViewHierarchy()
            setConstraints()
            print("Bind:", selectedBook?.title)
            guard let selectedBook = selectedBook else {return}
            bookTitle.text = selectedBook.title
            coverImageView.kf.setImage(with: URL(string: selectedBook.coverUrl))
            author.text = selectedBook.author
            introduction.text = selectedBook.descriptionOfBook
            publisher.text = selectedBook.publisher
            isbn.text = selectedBook.isbn
            page.text = "\(selectedBook.currentReadingPage) / \(selectedBook.page)"
            
            //readbutton
            if selectedBook.readingStatus == .reading{
                readButton.isHidden = false
                memoButton.isHidden = false
            }else{
                readButton.isHidden = true
                memoButton.isHidden = true
                
            }
        }
        
    }
    
    deinit {
        print("DetailViewController deinit")
    }
    
}

extension DetailViewController: UIScrollViewDelegate{
    
}

//MARK: functions
extension DetailViewController{
    
    @objc func readBook(){
//        print(#function)
        guard let book = vm.book.value else {return}
        if book.readingStatus == .toRead{
            vm.startReading {
                self.startReadingButton.isHidden = true
                
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
