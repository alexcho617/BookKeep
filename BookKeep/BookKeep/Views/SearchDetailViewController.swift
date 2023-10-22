//
//  SearchDetailViewController.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/30.
//

import UIKit
import SnapKit
import Kingfisher
import RealmSwift
import Toast

final class SearchDetailViewController: UIViewController {
    var isbn13Identifier: String = ""
    
    private let vm = SearchDetailViewModel()
    private var labelView = LabelViews()
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
        view.backgroundColor = .clear
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
            labelView.authorLabel,
            author,
            labelView.introductionLabel,
            introduction,
            labelView.publisherLabel,
            publisher,
            labelView.isbnLabel,
            isbn,
            labelView.pageLabel,
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
        vm.lookUp(id: isbn13Identifier) {
            let toast = Toast.text("❌조회 가능한 도서가 아닙니다")
            toast.show(haptic: .error)
            self.navigationController?.popViewController(animated: true)
        }
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
        vm.lookupResult.bind { [self] response in
            guard let book = response?.item.first else {return}
            bookTitle.text = book.title
            coverImageView.kf.indicatorType = .activity
            coverImageView.kf.setImage(
                with: URL(string: book.cover),
                placeholder: UIImage(named: "photo"),
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            author.text = book.author
            introduction.text = book.description
            publisher.text = book.publisher
            isbn.text = book.isbn13
            page.text = String(book.subInfo?.itemPage ?? -1)
            
        }
    }
    
    @objc private func addToReadingList(){
        guard let bookData = vm.lookupResult.value?.item.first else {return}
//        let book = RealmBook(isbn: bookData.isbn13, title: bookData.title, coverUrl: bookData.cover, author: bookData.author, descriptionOfBook: bookData.description, publisher: bookData.publisher, page: bookData.subInfo?.itemPage ?? 0, readItration: 0)
        
        let book = RealmBook(
                isbn: bookData.isbn13,
                title: bookData.title,
                coverUrl: bookData.cover,
                author: bookData.author,
                descriptionOfBook: bookData.description,
                publisher: bookData.publisher,
                page: bookData.subInfo?.itemPage ?? 0,
                readItration: 0,
                itemLink: bookData.link,
                priceSales: bookData.priceSales,
                priceStandard: bookData.priceStandard,
                categoryId: bookData.categoryID,
                categoryName: bookData.categoryName,
                customerReviewRank: bookData.customerReviewRank,
                adult: bookData.adult
            )
        
        do {
            //MARK: 여기선 VM을 거치지 않고 왜 Repository로 바로 갔지?
            try BooksRepository.shared.create(book)
            let toast = Toast.text("📖읽을 예정인 책에 추가되었습니다")
            toast.show(haptic: .success)
            self.navigationController?.popViewController(animated: true)
        } catch {
            let toast = Toast.text("❌이미 존재하는 책입니다")
            toast.show(haptic: .error)
        }
        
       
    }
    
    
    
    deinit {
        print("SearchDetailViewController deinit")
    }

}

extension SearchDetailViewController: UIScrollViewDelegate{
    
}
