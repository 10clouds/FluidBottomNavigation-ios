//
//  FluidTabBarItemContentView.swift
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

open class FluidTabBarItemContentView: UIView {

    // MARK: Public properties

    /// Performs state change animations
    open lazy var animator: FluidTabBarItemAnimator = {
        let animation = FluidTabBarItemAnimatorDefault()
        animation.contentView = self
        return animation
    }()

    open var selected = false

    open var highlighted = false

    open var highlightEnabled = true

    /// Icon imageView renderingMode, default is .alwaysTemplate like UITabBarItem
    open var renderingMode: UIImageRenderingMode = .alwaysTemplate {
        didSet {
            self.updateDisplay()
        }
    }

    /// Sets the color of selected item's image and text
    open override var tintColor: UIColor! {
        didSet {
            highlightTextColor = tintColor
            highlightImageColor = tintColor
        }
    }

    open var image: UIImage? {
        didSet {
            if !selected { self.updateDisplay() }
        }
    }

    open var selectedImage: UIImage? {
        didSet {
            if selected { self.updateDisplay() }
        }
    }

    open var title: String? {
        didSet {
            self.titleLabel.text = title
            self.updateLayout()
        }
    }

    /// Text color of not selected item
    open var textColor = UIColor(white: 0.57254902, alpha: 1.0) {
        didSet {
            if !selected {
                titleLabel.textColor = textColor
            }
        }
    }

    /// Text color of selected item
    open var highlightTextColor = UIColor(red: 0.0, green: 0.47843137, blue: 1.0, alpha: 1.0) {
        didSet {
            if selected {
                titleLabel.textColor = highlightImageColor
            }
        }
    }

    /// Image color of not selected item
    open var imageColor = UIColor(white: 0.57254902, alpha: 1.0) {
        didSet {
            if !selected {
                imageView.tintColor = imageColor
            }
        }
    }

    /// Image color of selected item
    open var highlightImageColor: UIColor = UIColor(red: 0.0, green: 0.47843137, blue: 1.0, alpha: 1.0) {
        didSet {
            if selected {
                imageView.tintColor = highlightImageColor
            }
        }
    }

    open var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .clear
        return imageView
    }()

    open var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .clear
        titleLabel.textAlignment = .center
        return titleLabel
    }()

    internal let imageViewContainer = UIView()

    // MARK: Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false

        addSubview(imageViewContainer)
        imageViewContainer.addSubview(imageView)
        addSubview(titleLabel)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public methods

    /// Updates the contents of titleLabel and imageView depending on the selection
    open func updateDisplay() {
        imageView.image = (selected ? (selectedImage ?? image) : image)?.withRenderingMode(renderingMode)
        imageView.tintColor = selected ? highlightImageColor : imageColor
        titleLabel.textColor = selected ? highlightTextColor : textColor
    }

    /// Updates the content view layout
    open func updateLayout() {
        let width = bounds.size.width
        let height = bounds.size.height

        imageView.isHidden = imageView.image == nil
        titleLabel.isHidden = titleLabel.text == nil

        var imageSize: CGFloat = 0.0
        var fontSize: CGFloat = 0.0
        var isLandscape = false
        if let keyWindow = UIApplication.shared.keyWindow {
            isLandscape = keyWindow.bounds.width > keyWindow.bounds.height
        }
        // is landscape or regular
        let isWide = animator.allowsLandscapeIconsArrangement && (isLandscape || traitCollection.horizontalSizeClass == .regular)
        if #available(iOS 11.0, *), isWide {
            imageSize = UIScreen.main.scale == 3.0 ? 23.0 : 20.0
            fontSize = UIScreen.main.scale == 3.0 ? 13.0 : 12.0
        } else {
            imageSize = 30.0
            fontSize = 13.0
        }

        if !imageView.isHidden && !titleLabel.isHidden {
            titleLabel.font = UIFont.systemFont(ofSize: fontSize)
            titleLabel.sizeToFit()
            if #available(iOS 11.0, *), isWide {
                titleLabel.frame = CGRect(
                    x: (width - titleLabel.bounds.size.width) / 2.0 + (UIScreen.main.scale == 3.0 ? 14.25 : 12.25),
                    y: (height - titleLabel.bounds.size.height) / 2.0,
                    width: titleLabel.bounds.size.width,
                    height: titleLabel.bounds.size.height
                )
                imageViewContainer.frame = CGRect(
                    x: titleLabel.frame.origin.x - imageSize - (UIScreen.main.scale == 3.0 ? 6.0 : 5.0),
                    y: (height - imageSize) / 2.0,
                    width: imageSize,
                    height: imageSize
                )
            } else {
                titleLabel.frame = CGRect(
                    x: (width - titleLabel.bounds.size.width) / 2.0,
                    y: height - titleLabel.bounds.size.height - 1.0,
                    width: titleLabel.bounds.size.width,
                    height: titleLabel.bounds.size.height
                )
                imageViewContainer.frame = CGRect(
                    x: (width - imageSize) / 2.0,
                    y: (height - imageSize) / 2.0 - 6.0,
                    width: imageSize,
                    height: imageSize
                )
            }
        } else if !imageView.isHidden {
            imageViewContainer.frame = CGRect(
                x: (width - imageSize) / 2.0,
                y: (height - imageSize) / 2.0,
                width: imageSize,
                height: imageSize
            )
        } else if !titleLabel.isHidden {
            titleLabel.font = UIFont.systemFont(ofSize: fontSize)
            titleLabel.sizeToFit()
            titleLabel.frame = CGRect(
                x: (width - titleLabel.bounds.size.width) / 2.0,
                y: (height - titleLabel.bounds.size.height) / 2.0,
                width: titleLabel.bounds.size.width,
                height: titleLabel.bounds.size.height
            )
        }

        imageView.frame = imageViewContainer.bounds

        animator.initialize()
        if selected {
            select(animated: false, completion: nil)
        }
    }
}

extension FluidTabBarItemContentView {
    internal func select(animated: Bool, completion: (() -> ())?) {
        selected = true
        if highlightEnabled && highlighted {
            highlighted = false
            animator.dehighlightAnimation(animated: animated, completion: { [weak self] in
                self?.updateDisplay()
                self?.animator.selectAnimation(animated: animated, completion: completion)
            })
        } else {
            updateDisplay()
            animator.selectAnimation(animated: animated, completion: completion)
        }
    }

    internal func deselect(animated: Bool, completion: (() -> ())?) {
        selected = false
        updateDisplay()
        animator.deselectAnimation(animated: animated, completion: completion)
    }

    internal func reselect(animated: Bool, completion: (() -> ())?) {
        if selected == false {
            select(animated: animated, completion: completion)
        } else {
            if highlightEnabled && highlighted {
                highlighted = false
                animator.dehighlightAnimation(animated: animated, completion: { [weak self] in
                    self?.animator.reselectAnimation(animated: animated, completion: completion)
                })
            } else {
                animator.reselectAnimation(animated: animated, completion: completion)
            }
        }
    }

    internal func highlight(animated: Bool, completion: (() -> ())?) {
        if !highlightEnabled || highlighted {
            return
        }
        highlighted = true
        self.animator.highlightAnimation(animated: animated, completion: completion)
    }

    internal func dehighlight(animated: Bool, completion: (() -> ())?) {
        if !highlightEnabled || !highlighted {
            return
        }
        highlighted = false
        animator.dehighlightAnimation(animated: animated, completion: completion)
    }
}
