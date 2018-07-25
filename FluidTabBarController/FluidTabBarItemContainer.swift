//
//  FluidTabBarItemContainer.swift
//  FluidTabBarController
//
//  Created by Vincent Li on 2017/2/8.
//  Copyright (c) 2013-2018 ESTabBarController (https://github.com/eggswift/ESTabBarController)
//
//  Modified by Hubert Kuczyński on 09/07/2018.
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
