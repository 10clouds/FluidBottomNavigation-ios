//
//  AppDelegate.swift
//  FluidTabBarController
//
//  Created by Hubert Kuczyński on 07/23/2018.
//  Copyright (c) 2018 Hubert Kuczyński. All rights reserved.
//

import UIKit
import FluidTabBarController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = createTabBarController()
        window?.makeKeyAndVisible()
        return true
    }

    private func createTabBarController() -> UITabBarController {
        let tabBarController = FluidTabBarController()
        tabBarController.tabBar.tintColor = UIColor(red: 0.2431372549, green: 0.4235294118, blue: 1, alpha: 1)
        let viewControllers = [
            ("News", #imageLiteral(resourceName: "news")),
            ("Requests", #imageLiteral(resourceName: "requests")),
            ("Events", #imageLiteral(resourceName: "events")),
            ("Members", #imageLiteral(resourceName: "members")),
            ("Account", #imageLiteral(resourceName: "profile"))
            ].map(createSampleViewController)
        tabBarController.setViewControllers(viewControllers, animated: true)
        return tabBarController
    }

    private func createSampleViewController(title: String, icon: UIImage) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9529411765, blue: 0.968627451, alpha: 1)
        let item = FluidTabBarItem(title: title, image: icon, tag: 0)
        item.imageColor = #colorLiteral(red: 0.7960784314, green: 0.8078431373, blue: 0.8588235294, alpha: 1)
        viewController.tabBarItem = item
        return viewController
    }
}

