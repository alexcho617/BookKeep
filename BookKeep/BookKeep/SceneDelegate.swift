//
//  SceneDelegate.swift
//  BookKeep
//
//  Created by Alex Cho on 2023/09/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let tabBarController = UITabBarController()
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let achievedVC = UINavigationController(rootViewController: AchievedViewController())
        let settingVC = UINavigationController(rootViewController: SettingsViewController())
        
        tabBarController.setViewControllers([homeVC, achievedVC, settingVC], animated: true)
        tabBarController.tabBar.tintColor = Design.colorPrimaryAccent
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = Design.colorPrimaryBackground
        tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearance //끝에 있을때: 맨 아래로 내려가있을때
        tabBarController.tabBar.standardAppearance = tabBarAppearance //끝에 닿지 않을때 NavigationBar랑 반대임
        
        if let items = tabBarController.tabBar.items{
            items[0].image = UIImage(systemName: "house.fill")
            items[0].title = "홈"
            
            items[1].image = UIImage(systemName: "medal.fill")
            items[1].title = "업적"
            
            items[2].image = UIImage(systemName: "gearshape.fill")
            items[2].title = "세팅"
        }
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
      
        print(#function)

    }

    func sceneDidBecomeActive(_ scene: UIScene) {
      
        print(#function)
        UIViewController.printUserDefaultsStatus()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
        print(#function)

    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }


}

