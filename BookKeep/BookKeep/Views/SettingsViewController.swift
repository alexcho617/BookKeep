//
//  SettingsViewController.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/19.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    func setView(){
        view.backgroundColor = Design.colorPrimaryBackground
        title = "세팅"
    }


}
