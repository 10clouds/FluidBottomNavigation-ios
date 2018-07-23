//
//  FluidTabBar.swift
//  FluidTabBarController
//
//  Created by Hubert Kuczyński on 09/07/2018.
//  Copyright © 2018 10Clouds Sp. z o.o. All rights reserved.
//

import UIKit

final class FluidTabBar: UITabBar {

    // MARK: Public properties

    public var itemEdgeInsets = UIEdgeInsets.zero

    internal var containers = [FluidTabBarItemContainer]()

    internal weak var tabBarController: UITabBarController?

    open override var items: [UITabBarItem]? {
        didSet {
            self.reload()
        }
    }

    override var barTintColor: UIColor? {
        didSet {
            updateTopLineColor()
        }
    }

    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        updateTopLineColor()
        isTranslucent = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public methods

    open override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }

    open override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        super.setItems(items, animated: animated)
        reload()
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var superPointInside = super.point(inside: point, with: event)
        if !superPointInside {
            for container in containers {
                if container.point(inside: CGPoint.init(x: point.x - container.frame.origin.x, y: point.y - container.frame.origin.y), with: event) {
                    superPointInside = true
                }
            }
        }
        return superPointInside
    }

    private func updateTopLineColor() {
        let color = barTintColor ?? .white
        shadowImage = UIImage.colorForNavBar(color: color)
        backgroundImage = UIImage.colorForNavBar(color: color)
    }
}

extension FluidTabBar {
    internal func updateLayout() {
        guard let tabBarItems = self.items else { return }

        let tabBarButtons = subviews.filter { subview -> Bool in
            if let cls = NSClassFromString("UITabBarButton") {
                return subview.isKind(of: cls)
            }
            return false
            }
            .sorted { (subview1, subview2) -> Bool in
                return subview1.frame.origin.x < subview2.frame.origin.x
        }

        for (idx, item) in tabBarItems.enumerated() {
            tabBarButtons[idx].isHidden = item is FluidTabBarItem
        }
        for (_, container) in containers.enumerated(){
            container.isHidden = false
        }

        for (idx, container) in containers.enumerated(){
            container.frame = tabBarButtons[idx].frame
        }
    }
}

extension FluidTabBar {
    internal func removeAll() {
        for container in containers {
            container.removeFromSuperview()
        }
        containers.removeAll()
    }

    internal func reload() {
        removeAll()
        guard let tabBarItems = self.items else {
            return
        }
        for (idx, item) in tabBarItems.enumerated() {
            let container = FluidTabBarItemContainer.init(self, tag: 1000 + idx)
            self.addSubview(container)
            self.containers.append(container)

            if let item = item as? FluidTabBarItem {
                item.contentView.backgroundColor = barTintColor
                item.contentView.tintColor = tintColor
                container.addSubview(item.contentView)
            }
        }

        self.setNeedsLayout()
    }

    @objc internal func highlightAction(_ sender: AnyObject?) {
        guard let container = sender as? FluidTabBarItemContainer else {
            return
        }
        let newIndex = max(0, container.tag - 1000)
        guard newIndex < items?.count ?? 0, let item = self.items?[newIndex], item.isEnabled == true else {
            return
        }

        if let item = item as? FluidTabBarItem {
            item.contentView.highlight(animated: true, completion: nil)
        }
    }

    @objc internal func dehighlightAction(_ sender: AnyObject?) {
        guard let container = sender as? FluidTabBarItemContainer else {
            return
        }
        let newIndex = max(0, container.tag - 1000)
        guard newIndex < items?.count ?? 0, let item = self.items?[newIndex], item.isEnabled == true else {
            return
        }

        if let item = item as? FluidTabBarItem {
            item.contentView.dehighlight(animated: true, completion: nil)
        }
    }

    @objc internal func selectAction(_ sender: AnyObject?) {
        guard let container = sender as? FluidTabBarItemContainer else {
            return
        }
        select(itemAtIndex: container.tag - 1000, animated: true)
    }

    @objc internal func select(itemAtIndex idx: Int, animated: Bool) {
        let newIndex = max(0, idx)
        let currentIndex = (selectedItem != nil) ? (items?.index(of: selectedItem!) ?? -1) : -1
        guard newIndex < items?.count ?? 0, let item = self.items?[newIndex], item.isEnabled else {
            return
        }

        if currentIndex != newIndex {
            if currentIndex != -1 && currentIndex < items?.count ?? 0{
                if let currentItem = items?[currentIndex] as? FluidTabBarItem {
                    currentItem.contentView.deselect(animated: animated, completion: nil)
                }
            }
            if let item = item as? FluidTabBarItem {
                item.contentView.select(animated: animated, completion: nil)
            }
            delegate?.tabBar?(self, didSelect: item)
        } else if currentIndex == newIndex {
            if let item = item as? FluidTabBarItem {
                item.contentView.reselect(animated: animated, completion: nil)
            }

            if let tabBarController = tabBarController {
                var navVC: UINavigationController?
                if let navigationController = tabBarController.selectedViewController as? UINavigationController {
                    navVC = navigationController
                } else if let tabBarController = tabBarController.selectedViewController?.navigationController {
                    navVC = tabBarController
                }

                if let navVC = navVC {
                    if navVC.viewControllers.contains(tabBarController) {
                        if navVC.viewControllers.count > 1 && navVC.viewControllers.last != tabBarController {
                            navVC.popToViewController(tabBarController, animated: true);
                        }
                    } else {
                        if navVC.viewControllers.count > 1 {
                            navVC.popToRootViewController(animated: animated)
                        }
                    }
                }

            }
        }
    }
}

extension UIImage {
    class func colorForNavBar(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
