//
//  FluidTabBarController.swift
//  FluidTabBarController
//
//  Created by Hubert Kuczyński on 09/07/2018.
//  Copyright © 2018 10Clouds Sp. z o.o. All rights reserved.
//

import UIKit

open class FluidTabBarController: UITabBarController {

    // MARK: UIViewController lifecycle

    open override func viewDidLoad() {
        super.viewDidLoad()
        let tabBar = { () -> FluidTabBar in
            let tabBar = FluidTabBar()
            tabBar.delegate = self
            tabBar.tabBarController = self
            return tabBar
        }()
        self.setValue(tabBar, forKey: "tabBar")
    }

    // MARK: Public properties

    open override var selectedViewController: UIViewController? {
        willSet {
            guard let newValue = newValue else {
                return
            }
            guard !ignoreNextSelection else {
                ignoreNextSelection = false
                return
            }
            guard
                let tabBar = self.tabBar as? FluidTabBar,
                let items = tabBar.items,
                let index = viewControllers?.index(of: newValue)
                else { return }
            let value = (FluidTabBarController.isShowingMore(self) && index > items.count - 1) ? items.count - 1 : index
            tabBar.select(itemAtIndex: value, animated: false)
        }
    }

    open override var selectedIndex: Int {
        willSet {
            guard !ignoreNextSelection else {
                ignoreNextSelection = false
                return
            }
            guard let tabBar = self.tabBar as? FluidTabBar, let items = tabBar.items else {
                return
            }
            let value = (FluidTabBarController.isShowingMore(self) && newValue > items.count - 1) ? items.count - 1 : newValue
            tabBar.select(itemAtIndex: value, animated: false)
        }
    }

    // MARK: Private properties

    fileprivate var ignoreNextSelection = false

    // MARK: Public functions

    open static func isShowingMore(_ tabBarController: UITabBarController?) -> Bool {
        return tabBarController?.moreNavigationController.parent != nil
    }

    open override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let idx = tabBar.items?.index(of: item) else {
            return
        }
        if idx == tabBar.items!.count - 1, FluidTabBarController.isShowingMore(self) {
            ignoreNextSelection = true
            selectedViewController = moreNavigationController
            return;
        }
        if let vc = viewControllers?[idx] {
            ignoreNextSelection = true
            selectedIndex = idx
            delegate?.tabBarController?(self, didSelect: vc)
        }
    }

    open func tabBar(_ tabBar: UITabBar, shouldSelect item: UITabBarItem) -> Bool {
        if let idx = tabBar.items?.index(of: item), let vc = viewControllers?[idx] {
            return delegate?.tabBarController?(self, shouldSelect: vc) ?? true
        }
        return true
    }
}
