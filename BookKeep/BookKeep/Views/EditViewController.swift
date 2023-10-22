//
//  EditViewController.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/05.
//

import UIKit
import SnapKit
import SPConfetti
import Toast

class EditViewController: UIViewController{
    var isbn: String = ""
    weak var detailDelegate: DetailViewDelegate? //Detail ViewController
    
    
    lazy var vm = EditViewModel(isbn: isbn)
    let pageTextField = {
        let view = UITextField()
        view.backgroundColor = Design.colorPrimaryBackground
        view.keyboardType = .numberPad
        view.textAlignment = .center
        view.layer.cornerRadius = Design.paddingDefault
        return view
    }()
    
    let confirmButton = {
        let view = UIButton()
        view.setTitle("수정하기", for: .normal)
        view.titleLabel?.font = Design.fontAccentDefault
        view.setTitleColor(Design.colorTextTitle, for: .normal)
        view.backgroundColor = Design.colorPrimaryAccent
        view.layer.cornerRadius = Design.paddingDefault
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Design.colorSecondaryBackground
        pageTextField.delegate = self
        bindView()
        setView()
        
       
        
    }
    
    func bindView(){
        vm.pageInput.bind { page in
            self.pageTextField.text = page
        }
    }
    
    func setView(){
        view.addSubview(pageTextField)
        view.addSubview(confirmButton)
        view.snp.makeConstraints { make in
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            
        }
        if let page = vm.book?.currentReadingPage, page != 0{
            pageTextField.text = String(page)
        }
        pageTextField.placeholder = "0 ~ \(vm.book?.page ?? -1) 사이의 값을 입력하세요"
        
        pageTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        confirmButton.addTarget(self, action: #selector(confirmButtonClicked(_:)), for: .touchUpInside)
        pageTextField.becomeFirstResponder()
        pageTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Design.paddingDefault)
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        vm.pageInput.value = pageTextField.text
    }
    
    @objc func confirmButtonClicked(_ button: UIButton){
        

        if vm.validate(){
            view.endEditing(true)
            if vm.book?.currentReadingPage == vm.book?.page{
                BooksRepository.shared.bookFinished(isbn: isbn)
                SPConfetti.startAnimating(.centerWidthToDown, particles: [.triangle, .arc, .star, .heart], duration: 3)
                dismiss(animated: true) {
                    self.detailDelegate?.popToRootView()
                    self.detailDelegate?.showToast(title: Literal.bookFinished)
                }
            }else{
                dismiss(animated: true) {
                    let toast = Toast.text("✏️페이지가 수정되었습니다",config: .init(dismissBy: [.time(time: 2),.swipe(direction: .natural)]))
                    toast.show(haptic: .success)
                }
            }
        }else{
            let toast = Toast.text("⚠️\(0) ~ \(vm.book?.page ?? -999) 사이의 값을 입력하세요",config: .init(dismissBy: [.time(time: 2),.swipe(direction: .natural)]))
            toast.show(haptic: .error)
            vm.pageInput.value = nil
            
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        vm.pageInput.value = textField.text
    }
    
}
