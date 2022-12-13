//
//  AppDelegate.swift
//  shorts-demo
//
//  Created by Andre on 2022/12/8.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        presentShortsPage()
        
        return true
    }
    
    @objc private func presentShortsPage() {
        guard let window = window else {
            print("[❗️] Window is nil")
            return
        }
        
        let shortViewController = ShortsViewController()
        shortViewController.tabBarItem.title = "Shorts"
        shortViewController.tabBarItem.image = UIImage(named: "video")
        
        /// Setup basic tabbar
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [shortViewController]
        
        let appearance = UITabBarAppearance()
        if #available(iOS 13, *) {
            appearance.stackedLayoutAppearance.normal.iconColor = .white
            appearance.stackedLayoutAppearance.selected.iconColor = .white
            appearance.backgroundColor = .black
            tabBarController.tabBar.tintColor = .white
            tabBarController.tabBar.standardAppearance = appearance
        }
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}

