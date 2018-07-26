//
//  AppDelegate.swift
//  FluidTabBarController
//
//  Created by Hubert Kuczyński on 07/23/2018.
//  Copyright © 2018 10Clouds Sp. z o.o.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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

