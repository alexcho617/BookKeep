//
//  ReadingViewController.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/10.
//

import UIKit

final class ReadingViewController: UIViewController {
    var isbn: String = ""
    var vm: ReadingViewModel!
    
    lazy var closeButton: UIBarButtonItem = {
        let view = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(closeClicked))
        view.image = UIImage(systemName: "xmark")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Design.colorPrimaryAccent
        setView()
        setConstraints()
        bindView()
    }
    
    private func setView(){
        vm = ReadingViewModel(isbn: isbn)
        navigationItem.leftBarButtonItem = closeButton

    }
    
    @objc func closeClicked(){
        self.showActionAlert(title: "주의", message: "저장하지 않고 나가시겠습니까?") {
            print("ReadingViewController", #function)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setConstraints(){
        
    }
    
    private func bindView(){
        
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
