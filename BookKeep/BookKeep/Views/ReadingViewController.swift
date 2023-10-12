//
//  ReadingViewController.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/10.
//

import UIKit
import SnapKit

final class ReadingViewController: UIViewController {
    var isbn: String = ""
    var vm: ReadingViewModel!
    //views
    lazy var closeButton: UIBarButtonItem = {
        let view = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(closeClicked))
        view.image = UIImage(systemName: "xmark")
        return view
    }()
    
    lazy var doneButton: UIBarButtonItem = {
        let view = UIBarButtonItem(title: "독서완료", style: .plain, target: self, action: #selector(doneClicked))
        view.style = .done
        return view
    }()
    
    let nowReadingLabel = {
        let view = UILabel()
        view.text = Literal.mainReading
        view.font = Design.fontTitle
        view.textColor = Design.colorSecondaryAccent
        return view
    }()
    
    let bookTitle = {
        let view = UILabel()
        view.textColor = Design.colorTextSubTitle
        view.font = Design.fontSubTitle
        view.text = "제목"
        view.numberOfLines = 0
        return view
    }()
    
    let coverImageView = {
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
    let timerLabel = {
        let view = UILabel()
        view.text = "00:00"
        view.font = Design.fontTitle
        view.textColor = Design.colorPrimaryAccent
        return view
    }()
    
    let mainButton = {
        var config = UIButton.Configuration.tinted()
        config.baseForegroundColor = Design.colorPrimaryAccent
        config.baseBackgroundColor = Design.colorSecondaryBackground
        config.imagePadding = Design.paddingDefault
        config.imagePlacement = .top
        config.buttonSize = .large
        let view = UIButton(configuration: config)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraints()
        bindView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        UIViewController.printUserDefaultsStatus()
    }
    
    private func setView(){
        view.backgroundColor = Design.colorPrimaryBackground
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = doneButton
        vm = ReadingViewModel(isbn: isbn)
        view.addSubview(mainButton)
        mainButton.addTarget(self, action: #selector(mainButtonClicked), for: .touchUpInside)

        view.addSubview(nowReadingLabel)
        view.addSubview(timerLabel)

        view.addSubview(bookTitle)
        view.addSubview(coverImageView)
        

        

    }
    
    private func setConstraints(){
        nowReadingLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(Design.paddingDefault)
        }
        
        bookTitle.snp.makeConstraints { make in
            make.top.equalTo(nowReadingLabel.snp.bottom).offset(Design.paddingDefault)
            make.horizontalEdges.equalToSuperview().offset(Design.paddingDefault)
        }
        
        coverImageView.snp.makeConstraints { make in
            make.top.equalTo(bookTitle.snp.bottom).offset(2*Design.paddingDefault)
            make.centerX.equalToSuperview()
        }
        
        timerLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(2*Design.paddingDefault)
            make.centerX.equalToSuperview()
        }
        
        mainButton.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(Design.paddingDefault)
            make.centerX.equalToSuperview()
            make.width.equalTo(view).multipliedBy(0.3)
        }
    }
    
    private func bindView(){
        vm.elapsedTime.bind { timeInterval in
            self.timerLabel.text = timeInterval.converToValidFormat()
        }
        
        vm.readingState.bind { [self] value in
            if value == .reading{
                mainButton.setTitle("일시정지", for: .normal)
                mainButton.setImage(UIImage(systemName:"pause"), for: .normal)
            }else{
                mainButton.setTitle("다시시작", for: .normal)
                mainButton.setImage(UIImage(systemName:"play"), for: .normal)
            }
        }
        
        vm.book.bind { [self] book in
            guard let book = book else {return}
            bookTitle.text = book.title
            coverImageView.kf.setImage(
                with: URL(string: book.coverUrl),
                placeholder: UIImage(named: "photo"),
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
        }
    }

    @objc func closeClicked(){
        self.showActionAlert(title: "주의", message: "저장하지 않고 나가시겠습니까?") {
//            print("ReadingViewController", #function)
            self.vm.abortReading()
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    @objc func doneClicked(){
        //TODO: make reading done UIVIew
//        self.vm.doneReading()
        //check if book is finished
    }
    
    @objc func mainButtonClicked(){
        vm.mainButtonClicked()
    }
    
   
    
    private func showActionAlert(title: String, message: String, handler: (()->Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let confirmAction = UIAlertAction(title: "나가기", style: .destructive) { _ in
            handler?()
        }
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert,animated: true)
    }
    
    

}

//formatting
extension TimeInterval{
    func converToValidFormat() -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.calendar?.locale = Locale(identifier: "ko_KR")
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: self)
    }
}
