//
//  ReadCompleteViewController.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/14.
//

import UIKit
import SnapKit
import SPConfetti

final class ReadCompleteViewController: UIViewController {
    var isbn: String = ""
    var startTime: Date?
    var readTime: TimeInterval?
    var page: Int?
    var navigationHandler: (() -> Void)?
    
    lazy var vm = ReadCompleteViewModel(isbn: isbn)

    let titleLabel = {
        let view = UILabel()
        view.text = "책 타이틀을 렘에서 가져오쟈 책 타이틀을 렘에서 가져오쟈 책 타이틀을 렘에서 가져오쟈 책 타이틀을 렘에서 가져오쟈"
        view.numberOfLines = 2
        view.font = Design.fontAccentDefault
        view.textColor = UIColor.label
        return view
    }()
    
    let startDateLabel = {
        let view = UILabel()
        view.text = "시작시간"
        view.textColor = Design.colorPrimaryAccent
        view.font = Design.fontAccentDefault
        return view
    }()
    
    let startDatePicker = {
        let view = UIDatePicker()
        let style = UIDatePickerStyle.wheels
        
        return view
    }()
    
    let pageTextField = {
        let view = UITextField()
        view.backgroundColor = Design.colorPrimaryBackground
        view.placeholder = "몇 페이지까지 읽으셨나요?"
        view.keyboardType = .numberPad
        view.textAlignment = .center
        view.layer.cornerRadius = Design.paddingDefault
        return view
    }()
    
    let readTimeLabel = {
        let view = UILabel()
        view.text = "독서시간"
        view.textColor = Design.colorPrimaryAccent
        view.font = Design.fontAccentDefault
        return view
    }()
    
    let readTimePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .countDownTimer
        view.minuteInterval = 1
        view.roundsToMinuteInterval = true
        
        return view
    }()
    
    let confirmButton = {
        let view = UIButton()
        view.setTitle("저장하기", for: .normal)
        view.titleLabel?.font = Design.fontAccentDefault
        view.setTitleColor(Design.colorTextTitle, for: .normal)
        view.backgroundColor = Design.colorPrimaryAccent
        view.layer.cornerRadius = Design.paddingDefault
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        setView()
    }
    
    func bindView(){
        vm.pageInput.bind { page in
            self.pageTextField.text = page
        }
        vm.book.bind { book in
            self.titleLabel.text = book?.title
        }
        
    }
    
    func setView(){
        view.backgroundColor = Design.colorSecondaryBackground
        view.addSubview(titleLabel)
        view.addSubview(startDateLabel)
        view.addSubview(startDatePicker)
        view.addSubview(pageTextField)
        view.addSubview(readTimeLabel)
        view.addSubview(readTimePicker)
        view.addSubview(confirmButton)
        
        readTimePicker.countDownDuration = readTime ?? 300 //5분 기본 값
        pageTextField.delegate = self
        pageTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        confirmButton.addTarget(self, action: #selector(confirmButtonClicked(_:)), for: .touchUpInside)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2*Design.paddingDefault)
            make.horizontalEdges.equalToSuperview().inset(Design.paddingDefault)
        }
        
        startDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(Design.paddingDefault)
            make.centerY.equalTo(startDatePicker)
        }
        
        startDatePicker.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2*Design.paddingDefault)
            make.leading.equalTo(startDateLabel.snp.trailing).offset(Design.paddingDefault).priority(.high)
            make.trailing.lessThanOrEqualTo(view.safeAreaLayoutGuide).offset(-Design.paddingDefault)
        }
        
        pageTextField.snp.makeConstraints { make in
            make.top.equalTo(startDatePicker.snp.bottom).offset(2*Design.paddingDefault)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(Design.paddingDefault)
            make.height.equalTo(36)
        }
        
        readTimePicker.snp.makeConstraints { make in
            make.top.equalTo(pageTextField.snp.bottom).offset(Design.paddingDefault)
            make.leading.equalTo(readTimeLabel.snp.trailing).offset(Design.paddingDefault)
            make.trailing.lessThanOrEqualTo(view.safeAreaLayoutGuide).offset(-Design.paddingDefault)
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        
        readTimeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(readTimePicker)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(Design.paddingDefault)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(readTimePicker.snp.bottom).offset(2*Design.paddingDefault)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(Design.paddingDefault)
        }
        
    }
    
    private func clearUD(){
        print("DEBUG: UD will Clear")
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.LastReadingState.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.LastElapsedTime.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.LastISBN.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.LastStartTime.rawValue)
        print("DEBUG: UD is Cleared")
     }

}

extension ReadCompleteViewController: UITextFieldDelegate{
    
    @objc func confirmButtonClicked(_ button: UIButton){
        print(#function)
        vm.startTimeInput.value = startDatePicker.date
        vm.readTimeInput.value = readTimePicker.countDownDuration
        if vm.addSession(){
            //TODO: celebrate
            //책이 끝난 경우
            if vm.book.value?.currentReadingPage == vm.book.value?.page{
                //TODO: change readingState = .done
                BooksRepository.shared.updateBookReadingStatus(isbn: isbn, to: .done)
                SPConfetti.startAnimating(.centerWidthToDown, particles: [.triangle, .arc, .star, .heart], duration: 3)
                self.showAlert(title: "🎉🎉🎉", message: Literal.bookFinished){
                    self.dismiss(animated: true)
                    self.clearUD()
                    //ReadingVC에서 온 경우 홈 화면까지 간다. HomeVC에서 온 경우 collectionViewReload까지만
                    self.navigationHandler?()
                    
                }
            }else{
                //책이 끝나지 않고 세션만 추가 된 경우
                showAlert(title: "📚📚📚", message: Literal.readSessionDone){
                    self.view.endEditing(true)
                    self.dismiss(animated: true)
                    self.clearUD()
                    self.navigationHandler?()
                }
            }
            
            
            
        }else{
            showAlert(title: "삐빅!", message: "\(0) ~ \(vm.book.value?.page ?? -999) 사이의 값을 입력하세요", handler: nil)
            pageTextField.text = nil

        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        vm.pageInput.value = textField.text
    }
   
}
