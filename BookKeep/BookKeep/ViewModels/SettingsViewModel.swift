//
//  SettingsViewModel.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/10/19.
//

import Foundation

enum Sections: String{
    case personal = "개인"
    case app = "앱"
}
enum Items: String{
    case infoPolicy = "개인정보 처리"
    case sendEmail = "문의 보내기"
    case appVersion = "앱 버전"
    case openSource = "오픈소스 라이센스"
}

class SettingsViewModel{
   
    var sections = ["개인", "앱"]
    var items = [["개인정보 처리"],["문의 보내기", "오픈소스 라이센스", "앱 버전"]]
    var currentVersion: String{
        get {
            return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? " - "
        }
    }
   
    func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
    //추후 사용
    func latestVersion() -> String? {
        guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(Literal.appleID)"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
              let results = json["results"] as? [[String: Any]],
              let appStoreVersion = results[0]["version"] as? String else {
            print("DEBUG: 최신 버전 불러오기 실패")
            return nil
        }
        return appStoreVersion
    }
}
