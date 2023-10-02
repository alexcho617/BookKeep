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
    
    private var bookTitle = {
        let view = UILabel()
        view.textColor = Design.colorTextSubTitle
        view.font = Design.fontSubTitle
        view.text = "제목"
        view.numberOfLines = 0
        return view
    }()
    
    private var coverImageView = {
        let view = UIImageView()
        view.backgroundColor = Design.debugGray
        view.image = UIImage(systemName: "photo")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.borderColor = Design.colorPrimaryAccent?.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private var author = {
        let view = UILabel()
        view.text = "저자"
        view.font = Design.fontDefault
        view.textColor = Design.colorTextDefault
        view.numberOfLines = 0
        return view
    }()
    
    private var introduction = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = ""
        view.font = Design.fontDefault
        view.textColor = Design.colorTextDefault
        return view
    }()
    
    private var publisher = {
        let view = UILabel()
        view.text = "출판사"
        view.font = Design.fontDefault
        view.textColor = Design.colorTextDefault
        return view
    }()
    
    private var isbn = {
        let view = UILabel()
        view.text = "ISBN"
        view.font = Design.fontDefault
        view.textColor = Design.colorTextDefault
        return view
    }()
    
    private var page = {
        let view = UILabel()
        view.text = "페이지"
        view.font = Design.fontDefault
        view.textColor = Design.colorTextDefault
        return view
    }()
    
    
    
    lazy var scrollView = {
        let view = UIScrollView()
        view.delegate = self
        return view
    }()
    
    lazy var baseView = {
        let view = UIView()
        view.backgroundColor = Design.debugPink
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraints()
        bindData()
        vm.fetchBookFromRealm(isbn: isbn13Identifier)
    }
    
    func setView(){
        view.backgroundColor = Design.colorPrimaryBackground
        view.addSubview(scrollView)
        scrollView.addSubview(baseView)
        baseView.addSubview(bookTitle)
        baseView.addSubview(coverImageView)
    }
    
    func setConstraints(){
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        baseView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide).inset(Design.paddingDefault)
            make.width.equalTo(scrollView.snp.width).inset(Design.paddingDefault)
            make.height.greaterThanOrEqualTo(view.snp.height).priority(.low)
        }
        
        bookTitle.snp.makeConstraints { make in
        }
        
        coverImageView.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).multipliedBy(0.4)
            make.height.equalTo(coverImageView.snp.width).multipliedBy(1.4)
        }
    }
    
    func bindData(){
        vm.book.bind { [self] selectedBook in
            guard let selectedBook = selectedBook else {return}
            bookTitle.text = selectedBook.title
            coverImageView.kf.setImage(with: URL(string: selectedBook.coverUrl))
            author.text = selectedBook.author
            introduction.text = selectedBook.descriptionOfBook
            publisher.text = selectedBook.publisher
            isbn.text = selectedBook.isbn
            page.text = String(selectedBook.page)
        }
        
    }
    
    deinit {
        print("DetailViewController deinit")
    }
    
}

extension DetailViewController: UIScrollViewDelegate{
    
}
