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
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
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
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        print(#function)

    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        print(#function)
        UIViewController.printUserDefaultsStatus()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        print(#function)

    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

