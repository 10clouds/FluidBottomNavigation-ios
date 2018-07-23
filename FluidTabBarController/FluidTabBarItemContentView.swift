//
//  FluidTabBarItemContentView.swift
//  FluidTabBarController
//
//  Created by Hubert Kuczyński on 10/07/2018.
//  Copyright © 2018 10Clouds Sp. z o.o. All rights reserved.
//

import UIKit

public enum FluidTabBarItemContentMode: Int {
    case alwaysOriginal
    case alwaysTemplate
}

open class FluidTabBarItemContentView: UIView {

    // MARK: Public properties

    open lazy var animator: FluidTabBarItemAnimator = {
        let animation = FluidTabBarItemAnimatorDefault()
        animation.contentView = self
        return animation
    }()

    open var insets = UIEdgeInsets.zero

    open var selected = false

    open var highlighted = false

    open var highlightEnabled = true

    /// Icon imageView renderingMode, default is .alwaysTemplate like UITabBarItem
    open var renderingMode: UIImageRenderingMode = .alwaysTemplate {
        didSet {
            self.updateDisplay()
        }
    }

    /// Item content mode, default is .alwaysTemplate like UITabBarItem
    open var itemContentMode: FluidTabBarItemContentMode = .alwaysTemplate {
        didSet {
            self.updateDisplay()
        }
    }

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

    open var textColor = UIColor(white: 0.57254902, alpha: 1.0) {
        didSet {
            if !selected {
                titleLabel.textColor = textColor
            }
        }
    }

    open var highlightTextColor = UIColor(red: 0.0, green: 0.47843137, blue: 1.0, alpha: 1.0) {
        didSet {
            if selected {
                titleLabel.textColor = highlightImageColor
            }
        }
    }

    open var imageColor = UIColor(white: 0.57254902, alpha: 1.0) {
        didSet {
            if !selected {
                imageView.tintColor = imageColor
            }
        }
    }

    open var highlightImageColor: UIColor = UIColor(red: 0.0, green: 0.47843137, blue: 1.0, alpha: 1.0) {
        didSet {
            if selected {
                imageView.tintColor = highlightImageColor
            }
        }
    }

    let imageViewContainer = UIView()

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

    open func updateDisplay() {
        imageView.image = (selected ? (selectedImage ?? image) : image)?.withRenderingMode(renderingMode)
        imageView.tintColor = selected ? highlightImageColor : imageColor
        titleLabel.textColor = selected ? highlightTextColor : textColor
    }

    open func updateLayout() {
        let width = bounds.size.width
        let height = bounds.size.height

        imageView.isHidden = imageView.image == nil
        titleLabel.isHidden = titleLabel.text == nil

        if self.itemContentMode == .alwaysTemplate {
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
                imageSize = 23.0
                fontSize = 10.0
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

        } else {
            if !imageView.isHidden && !titleLabel.isHidden {
                titleLabel.sizeToFit()
                imageView.sizeToFit()
                titleLabel.frame = CGRect(
                    x: (width - titleLabel.bounds.size.width) / 2.0,
                    y: height - titleLabel.bounds.size.height - 1.0,
                    width: titleLabel.bounds.size.width,
                    height: titleLabel.bounds.size.height
                )
                imageViewContainer.frame = CGRect(
                    x: (width - imageView.bounds.size.width) / 2.0,
                    y: (height - imageView.bounds.size.height) / 2.0 - 6.0,
                    width: imageView.bounds.size.width,
                    height: imageView.bounds.size.height
                )
            } else if !imageView.isHidden {
                imageView.sizeToFit()
                imageViewContainer.center = CGPoint(x: width / 2.0, y: height / 2.0)
            } else if !titleLabel.isHidden {
                titleLabel.sizeToFit()
                titleLabel.center = CGPoint(x: width / 2.0, y: height / 2.0)
            }
        }

        imageView.frame = imageViewContainer.bounds

        animator.initialize()
        if selected {
            select(animated: false, completion: nil)
        }
    }
}

extension FluidTabBarItemContentView {
    internal final func select(animated: Bool, completion: (() -> ())?) {
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

    internal final func deselect(animated: Bool, completion: (() -> ())?) {
        selected = false
        updateDisplay()
        animator.deselectAnimation(animated: animated, completion: completion)
    }

    internal final func reselect(animated: Bool, completion: (() -> ())?) {
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

    internal final func highlight(animated: Bool, completion: (() -> ())?) {
        if !highlightEnabled || highlighted {
            return
        }
        highlighted = true
        self.animator.highlightAnimation(animated: animated, completion: completion)
    }

    internal final func dehighlight(animated: Bool, completion: (() -> ())?) {
        if !highlightEnabled || !highlighted {
            return
        }
        highlighted = false
        animator.dehighlightAnimation(animated: animated, completion: completion)
    }
}
