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
    private let vm = DetailViewModel()
    
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
    
    private var readButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "timer"), for: .normal)
        button.backgroundColor = Design.colorPrimaryAccent
        button.tintColor = Design.colorSecondaryAccent
        button.layer.cornerRadius = Design.paddingDefault
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    private var memoButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "note.text.badge.plus"), for: .normal)
        button.backgroundColor = Design.colorPrimaryAccent
        button.tintColor = Design.colorSecondaryAccent
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
    
    
    lazy var scrollView = {
        let view = UIScrollView()
        view.delegate = self
        return view
    }()
    
    lazy var baseView = {
        let view = UIView()
//        view.backgroundColor = Design.debugPink
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewHierarchy()
        setViewDesign()
        setConstraints()
        bindData()
        
        //get data from realm
        do {
            try vm.fetchBookFromRealm(isbn: isbn13Identifier)

        } catch {
            showAlert(title: "에러", message: "데이터베이스에서 책을 가져오는데 실패했습니다.") {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func setViewHierarchy(){
        navigationItem.rightBarButtonItem = menuButton
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(baseView)


        baseView.addSubview(bookTitle)
        baseView.addSubview(coverImageView)
        baseView.addSubview(author)
        baseView.addSubview(readButton)
        baseView.addSubview(memoButton)
//        baseView.addSubview(introduction)
//        baseView.addSubview(page)
        
        baseView.addSubview(LabelViews.authorLabel)
        baseView.addSubview(LabelViews.introductionLabel)
        baseView.addSubview(LabelViews.publisherLabel)
        baseView.addSubview(LabelViews.isbnLabel)
        baseView.addSubview(LabelViews.pageLabel)
        
    }
    
    func setViewDesign(){
        view.backgroundColor = Design.colorPrimaryBackground
    }
    
    func setConstraints(){
        //MARK: Scroll + Base views
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        baseView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide).inset(Design.paddingDefault)
            make.width.equalTo(scrollView.snp.width).inset(Design.paddingDefault)
            make.height.greaterThanOrEqualTo(view.snp.height).priority(.low)
        }
        
        //MARK: Inner Layout
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
    }
    @objc func showMenu(){
        showActionSheet(title: nil, message: nil)
    }
    func bindData(){
        vm.book.bind { [self] selectedBook in
            //update UI
            guard let selectedBook = selectedBook else {return}
            bookTitle.text = selectedBook.title
            coverImageView.kf.setImage(with: URL(string: selectedBook.coverUrl))
            author.text = selectedBook.author
            introduction.text = selectedBook.descriptionOfBook
            publisher.text = selectedBook.publisher
            isbn.text = selectedBook.isbn
            page.text = "\(selectedBook.currentReadingPage) / \(selectedBook.page)"
        }
        
    }
    
    deinit {
        print("DetailViewController deinit")
    }
    
}

extension DetailViewController: UIScrollViewDelegate{
    
}

extension DetailViewController{
    private func showActionSheet(title: String?, message: String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "책 삭제", style: .destructive) { _ in
            print("Delete From Realm")
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert,animated: true)
    }
}