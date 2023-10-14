//
//  ReadCompleteViewController.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/14.
//

import UIKit
import SnapKit

final class ReadCompleteViewController: UIViewController {
    var isbn: String?
    var startTime: Date?
    var readTime: TimeInterval?
    var page: Int?
    
    //todo: realm 에서 타이틀 가져오기
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

}

extension ReadCompleteViewController: UITextFieldDelegate{
    
    @objc func confirmButtonClicked(_ button: UIButton){
        print(#function)
        print(isbn)
        print(startDatePicker.date)
        print(pageTextField.text!)
        print(readTimePicker.countDownDuration)
        //TODO: Add validation and create ReadSession
        //TODO: Add to realm and handle navigation
//        if vm.validate(){
//            view.endEditing(true)
//            dismiss(animated: true)
//        }else{
//            showAlert(title: "삐빅!", message: "\(0) ~ \(vm.book?.page ?? -999) 사이의 값을 입력하세요", handler: nil)
//            pageTextField.text = nil
//
//        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print(textField.text!)
//        vm.pageInput.value = textField.text
    }
   
}
