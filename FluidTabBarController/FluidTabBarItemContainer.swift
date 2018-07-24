//
//  FluidTabBarItemContainer.swift
//  FluidTabBarController
//
//  Created by Hubert Kuczyński on 10/07/2018.
//  Copyright © 2018 10Clouds Sp. z o.o. All rights reserved.
//

import UIKit

final class FluidTabBarItemContainer: UIControl {

    // MARK: Initializers

    init(_ target: AnyObject?, tag: Int) {
        super.init(frame: .zero)
        self.tag = tag
        self.addTarget(target, action: #selector(FluidTabBar.selectAction(_:)), for: .touchUpInside)
        self.addTarget(target, action: #selector(FluidTabBar.highlightAction(_:)), for: .touchDown)
        self.addTarget(target, action: #selector(FluidTabBar.highlightAction(_:)), for: .touchDragEnter)
        self.addTarget(target, action: #selector(FluidTabBar.dehighlightAction(_:)), for: .touchDragExit)
        self.backgroundColor = .clear
        self.isAccessibilityElement = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public methods

    override func layoutSubviews() {
        super.layoutSubviews()
        for subview in self.subviews {
            if let subview = subview as? FluidTabBarItemContentView {
                subview.frame = bounds
                subview.updateLayout()
            }
        }
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var pointInside = super.point(inside: point, with: event)
        if !pointInside {
            for subview in self.subviews {
                pointInside = subview.point(
                    inside: CGPoint(x: point.x - subview.frame.origin.x, y: point.y - subview.frame.origin.y),
                    with: event
                )
            }
        }
        return pointInside
    }
}
