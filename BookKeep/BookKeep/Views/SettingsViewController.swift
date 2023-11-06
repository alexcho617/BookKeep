//
//  SettingsViewController.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/19.
//

import UIKit
import SnapKit
import Toast
import MessageUI
import WebKit

class SettingsViewController: UIViewController {
    let vm = SettingsViewModel()
    let tableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.backgroundColor = Design.colorPrimaryBackground
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraints()
    }
    func setView(){
        view.backgroundColor = Design.colorPrimaryAccent
        let appearance = UINavigationBarAppearance()
        appearance.shadowImage = UIImage()
        appearance.backgroundImage = UIImage()
        appearance.backgroundColor = Design.colorPrimaryAccent
        navigationController?.navigationBar.tintColor = Design.colorPrimaryBackground
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        title = "세팅"
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func setConstraints(){
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    
}


extension SettingsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.items[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return vm.sections[section]
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.backgroundColor = Design.colorPrimaryBackground
        let item = vm.items[indexPath.section][indexPath.row]
        let itemKind = Items(rawValue: item)
        switch itemKind {
        case .appVersion:
            cell.textLabel?.text = "\(item): v\(vm.currentVersion)"
            cell.isUserInteractionEnabled = false
        default:
            cell.textLabel?.text = item
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = vm.items[indexPath.section][indexPath.row]
        let itemKind = Items(rawValue: item)
        
        switch itemKind {
            
        case .infoPolicy:
            let vc = SimpleWebViewController()
            vc.urlString = Literal.policyURL
            navigationController?.pushViewController(vc, animated: true)
        case .sendEmail:
            sendMail()
        case .appReview:
            goToAppstore()
        case .openSource:
            let vc = SimpleWebViewController()
            vc.urlString = Literal.openSourceURL
            navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
        //deselect row
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
extension SettingsViewController{
    func goToAppstore(){
        if let appstoreURL = URL(string: "https://apps.apple.com/app/\(Literal.appleID)") {
            var components = URLComponents(url: appstoreURL, resolvingAgainstBaseURL: false)
            components?.queryItems = [
              URLQueryItem(name: "action", value: "write-review")
            ]
            guard let writeReviewURL = components?.url else {
                return
            }
            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
        }
    }
}
extension SettingsViewController: MFMailComposeViewControllerDelegate{
    func sendMail(){
        if MFMailComposeViewController.canSendMail(){
            let vc = MFMailComposeViewController()
            vc.mailComposeDelegate = self
            let bodyString = """
                                   이곳에 내용을 작성해주세요.
                                   
                                   
                                   
                                   
                                   
                                   -------------------
                                   Device Model : \(vm.getDeviceIdentifier())
                                   Device OS : \(UIDevice.current.systemVersion)
                                   App Version : \(vm.currentVersion)
                                   -------------------
                                   """
            vc.setToRecipients([Literal.developerEmail])
            vc.setSubject("[북킵] 문의 & 의견")
            vc.setMessageBody(bodyString, isHTML: false)
            present(vc, animated: true, completion: nil)
        }else{
            let toast = Toast.text("⚠️메일 전송을 실패했습니다")
            toast.show(haptic: .error)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true)
    }
    
}

class SimpleWebViewController: UIViewController{
    var urlString: String?
    private let webView = {
        let view = WKWebView()
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        let myRequest = URLRequest(url: URL(string: urlString ?? "www.velog.io/@alexcho617")!, timeoutInterval: 5)
        webView.load(myRequest)
    }
    
}
