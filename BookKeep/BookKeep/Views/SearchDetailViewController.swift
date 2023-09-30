//
//  SearchDetailViewController.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/30.
//

import UIKit
import SnapKit
import Kingfisher
final class SearchDetailViewController: UIViewController {
    var isbn13: String = ""
    
    private let vm = SearchDetailViewModel()
    
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
    
    //MARK: Labels
    private var authorLabel = {
        let view = UILabel()
        view.text = "저자"
        view.font = Design.fontAccentDefault
        view.textColor = Design.colorTextSubTitle
        return view
    }()
    private var introductionLabel = {
        let view = UILabel()
        view.text = "책 소개"
        view.font = Design.fontAccentDefault
        view.textColor = Design.colorTextSubTitle
        return view
    }()
    private var publisherLabel = {
        let view = UILabel()
        view.text = "출판사"
        view.font = Design.fontAccentDefault
        view.textColor = Design.colorTextSubTitle
        return view
    }()
    private var isbnLabel = {
        let view = UILabel()
        view.text = "ISBN"
        view.font = Design.fontAccentDefault
        view.textColor = Design.colorTextSubTitle
        return view
    }()
    private var pageLabel = {
        let view = UILabel()
        view.text = "페이지"
        view.font = Design.fontAccentDefault
        view.textColor = Design.colorTextSubTitle
        return view
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        let view = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(addToReadingList))
          return view
      }()
    
    var baseView: UIStackView!
    
    lazy var scrollView = {
        let view = UIScrollView()
        view.delegate = self
        return view
    }()
    
    lazy var stackView = {
        let view = UIStackView(arrangedSubviews: [
            bookTitle,
            coverImageView,
            authorLabel,
            author,
            introductionLabel,
            introduction,
            publisherLabel,
            publisher,
            isbnLabel,
            isbn,
            pageLabel,
            page
        ])
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = Design.paddingDefault
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraints()
        bindData()
        vm.lookUp(id: isbn13)

    }
    
    func setView(){
        navigationItem.rightBarButtonItem = addButton
        view.backgroundColor = Design.colorPrimaryBackground
        view.addSubview(scrollView)
        title = "책 추가하기"
        scrollView.addSubview(stackView)
    }
    
    func setConstraints(){

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide).inset(Design.paddingDefault)
            make.width.equalTo(scrollView.snp.width)
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
        vm.lookupResult.bind { [self] response in
            guard let book = response?.item.first else {return}
            bookTitle.text = book.title
            coverImageView.kf.setImage(with: URL(string: book.cover))
            author.text = book.author
            introduction.text = book.description
            publisher.text = book.publisher
            isbn.text = book.isbn13
            page.text = String(book.subInfo.itemPage ?? -1)
            
        }
    }
    @objc private func addToReadingList(){
        print(#function)
        //TODO:
        //create RealmBook Object
        //add to realm
        //TOAST 띄우기
        //go back to homescreen: 1.pop until homeview or 2.change rootview by using makeKeyAndVisible
    }
    
    deinit {
        print("SearchDetailViewController deinit")
    }

}

extension SearchDetailViewController: UIScrollViewDelegate{
    
}
