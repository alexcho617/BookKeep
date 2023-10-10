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
    
    let timerLabel = {
        let view = UILabel()
        view.text = "00:00"
        view.font = Design.fontSubTitle
        view.textColor = Design.colorPrimaryAccent
        return view
    }()
    
    let mainButton = {
        let view = UIButton()
        view.setTitleColor(UIColor.label, for: .normal)
        view.setTitle("Play", for: .normal)
        view.setTitleColor(Design.colorPrimaryAccent, for: .normal)
        view.setImage(UIImage(systemName: "play"), for: .normal)
        view.tintColor = Design.colorPrimaryAccent
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraints()
        bindView()
    }
    
    private func setView(){
        view.backgroundColor = Design.colorPrimaryBackground
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = doneButton
        vm = ReadingViewModel(isbn: isbn)
        
        view.addSubview(timerLabel)
        view.addSubview(mainButton)
        mainButton.addTarget(self, action: #selector(mainButtonClicked), for: .touchUpInside)

        

    }
    
    private func setConstraints(){
        timerLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        mainButton.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }
    
    private func bindView(){
        vm.currentTime.bind { timeInterval in
            self.timerLabel.text = timeInterval.converToValidFormat()
        }
        
        vm.timerState.bind { [self] value in
            if value == .reading{
                mainButton.setTitle("Pause", for: .normal)
                mainButton.setImage(UIImage(systemName:"pause"), for: .normal)
            }else{
                mainButton.setTitle("Play", for: .normal)
                mainButton.setImage(UIImage(systemName:"play"), for: .normal)
            }
        }
    }

    @objc func closeClicked(){
        self.showActionAlert(title: "주의", message: "저장하지 않고 나가시겠습니까?") {
//            print("ReadingViewController", #function)
            self.vm.exitProcedue()
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    @objc func doneClicked(){
        print("ReadingVC",#function)
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
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: self)
    }
}
