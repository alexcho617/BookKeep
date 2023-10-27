//
//  ViewController + Background.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/28.
//

import UIKit
import SnapKit
import SPConfetti

extension UIViewController{
    
    func showAlert(title: String, message: String, handler: (()->Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            handler?()
        }
        alert.addAction(confirmAction)
        present(alert,animated: true)
    }
    
    func addBaseView() -> UIStackView{
        var upper: UIView {
            let view = UIView()
            view.backgroundColor = Design.colorPrimaryAccent
            return view
        }
        
        var lower: UIView {
            let view = UIView()
            view.backgroundColor = Design.colorPrimaryBackground
            return view
        }
        
        let base = UIStackView(arrangedSubviews: [upper, lower])
        base.axis = .vertical
        base.distribution = .fillEqually
        return base
    }
    
    static func printUserDefaultsStatus(){
        let elapsedTime = UserDefaults.standard.value(forKey: UserDefaultsKey.LastElapsedTime.rawValue) ?? "nil"
        let state = UserDefaults.standard.value(forKey: UserDefaultsKey.LastReadingState.rawValue) ?? "nil"
        let isbn = UserDefaults.standard.value(forKey: UserDefaultsKey.LastISBN.rawValue) ?? "nil"
        let startTime = UserDefaults.standard.value(forKey: UserDefaultsKey.LastStartTime.rawValue) ?? "nil"

//        print("DEBUG UD - Time:\(elapsedTime) State:\(state) ISBN:\(isbn) Started At:\(startTime)")
    }
}
