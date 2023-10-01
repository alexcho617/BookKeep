//
//  ViewController + Background.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/28.
//

import UIKit
import SnapKit

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
    
}
