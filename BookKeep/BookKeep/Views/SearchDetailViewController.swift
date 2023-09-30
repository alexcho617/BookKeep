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
        view.textColor = Design.colorTextTitle
        view.font = Design.fontTitle
        view.backgroundColor = Design.debugGray
        view.text = "제목"
        return view
    }()
    
    private var coverImageView = {
        let view = UIImageView()
        view.backgroundColor = Design.debugGray
        view.image = UIImage(systemName: "photo")
        return view
    }()
    
    private var author = {
        let view = UILabel()
        view.text = "저자"
        return view
    }()
    
    private var introduction = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = """
            "살인자의 기억법"은 한국 문학계의 거장, 김영하 작가의 대표작 중 하나입니다. 이 소설은 단순한 범죄 소설이 아닌, 범인의 시선에서 이야기가 풀려나가는 독특한 구성이 특징입니다. 살인범과 경찰, 피해자의 시선에서 서로 다른 이야기가 공존하며, 독자는 각 시각에서 벌어지는 사건을 체험할 수 있습니다. 김영하 작가의 탁월한 문장력과 감정 묘사는 이 작품을 더욱 특별하게 만듭니다."살인자의 기억법"은 한국 문학계의 거장, 김영하 작가의 대표작 중 하나입니다. 이 소설은 단순한 범죄 소설이 아닌, 범인의 시선에서 이야기가 풀려나가는 독특한 구성이 특징입니다. 살인범과 경찰, 피해자의 시선에서 서로 다른 이야기가 공존하며, 독자는 각 시각에서 벌어지는 사건을 체험할 수 있습니다. 김영하 작가의 탁월한 문장력과 감정 묘사는 이 작품을 더욱 특별하게 만듭니다.
            """
        return view
    }()
    
    private var publisher = {
        let view = UILabel()
        view.text = "출판사"
        return view
    }()
    
    private var isbn = {
        let view = UILabel()
        view.text = "ISBN"
        return view
    }()
    
    private var page = {
        let view = UILabel()
        view.text = "페이지"
        return view
    }()
    
    private var addButton = {
        let view = UIButton()
        view.setTitle("저장", for: .normal)
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
            author,
            introduction,
            publisher,
            isbn,
            page
        ])
        view.axis = .vertical
        view.alignment = .leading
//        view.distribution = 
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
        baseView = addBaseView()
        view.addSubview(baseView)
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    
    func setConstraints(){
        baseView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.snp.width)
            make.height.greaterThanOrEqualTo(view.snp.height).priority(.low)
        }
        bookTitle.snp.makeConstraints { make in
        }
        coverImageView.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).multipliedBy(0.4)
            make.height.equalTo(coverImageView.snp.width).multipliedBy(1.3)
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
    func addToReadingList(){
        //TODO:
        //create RealmBook Object
        //add to realm
        //go back to homescreen: 1.pop until homeview or 2.change rootview by using makeKeyAndVisible
    }
    
    deinit {
        print("SearchDetailViewController deinit")
    }

}

extension SearchDetailViewController: UIScrollViewDelegate{
    
}
