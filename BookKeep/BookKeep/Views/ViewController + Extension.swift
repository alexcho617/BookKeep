//
//  ViewController + Background.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/28.
//

import UIKit
import SnapKit

extension UIViewController{
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
    
    func transition(style: TransitionStyle, viewController: UIViewController) //viewController의 타입 그 자체가 들어온다
{
//        let vc = T()
        switch style {
        case .present:
            present(viewController,animated: true)
            
        case .presentWithNavigation:
            let nc = UINavigationController(rootViewController: viewController)
            present(nc, animated: true)
            
        case .presentWithFullNavigation:
            let nc = UINavigationController(rootViewController: viewController)
            nc.modalPresentationStyle = .fullScreen
            present(nc,animated: true)
            
        case .push:
            let nc = UINavigationController(rootViewController: viewController)
            navigationController?.pushViewController(nc, animated: true)
        }
    }
}
