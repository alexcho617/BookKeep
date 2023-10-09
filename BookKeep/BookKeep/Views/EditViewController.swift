//
//  EditViewController.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/05.
//

import UIKit
import SnapKit
class EditViewController: UIViewController{
    var isbn: String = ""
 
    lazy var vm = EditViewModel(isbn: isbn)
    let pageTextField = {
        let view = UITextField()
        view.backgroundColor = Design.colorPrimaryBackground
        view.placeholder = "몇 페이지까지 읽으셨나요?"
        view.keyboardType = .numberPad
        view.textAlignment = .center
        return view
    }()
    let spacerView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    let confirmButton = {
        let view = UIButton()
        view.setTitle("수정하기", for: .normal)
        view.titleLabel?.font = Design.fontAccentDefault
        view.setTitleColor(Design.colorTextTitle, for: .normal)
        view.backgroundColor = Design.colorPrimaryAccent
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Design.colorSecondaryBackground
        pageTextField.delegate = self
        bindView()
        setView()
        
        //페이지 존재하면 넣어줌
        guard let page = vm.book?.currentReadingPage, page != 0 else {
            pageTextField.text = nil
            return
        }
        pageTextField.text = String(page)
    }
    
    func bindView(){
        vm.pageInput.bind { page in
            self.pageTextField.text = page
        }
    }
    
    func setView(){
        view.addSubview(pageTextField)
        view.addSubview(confirmButton)
        
        pageTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        confirmButton.addTarget(self, action: #selector(confirmButtonClicked(_:)), for: .touchUpInside)
        
        pageTextField.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Design.paddingDefault)
            make.height.equalTo(36)
        }

        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(pageTextField.snp.bottom).offset(40)
            make.height.equalTo(44).priority(.low)
            make.horizontalEdges.equalTo(pageTextField)
            
        }
        
    }
}

extension EditViewController: UITextFieldDelegate{
    
    @objc func confirmButtonClicked(_ button: UIButton){
        if vm.validate(){
            view.endEditing(true)
            dismiss(animated: true)
        }else{
            showAlert(title: "삐빅!", message: "\(0) ~ \(vm.book?.page ?? -999) 사이의 값을 입력하세요", handler: nil)
            pageTextField.text = nil

        }
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        vm.pageInput.value = textField.text
    }
   
}
