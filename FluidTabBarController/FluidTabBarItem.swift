//
//  FluidTabBarItem.swift
//  FluidTabBarController
//
//  Created by Hubert Kuczyński on 09/07/2018.
//  Copyright © 2018 10Clouds Sp. z o.o. All rights reserved.
//

import UIKit

open class FluidTabBarItem: UITabBarItem {

    // MARK: Public properties

    open override var title: String? {
        didSet { self.contentView.title = title }
    }

    open var textColor: UIColor {
        get { return contentView.textColor }
        set { contentView.textColor = newValue }
    }

    open var highlightTextColor: UIColor {
        get { return contentView.highlightTextColor }
        set { contentView.highlightTextColor = newValue }
    }

    open var imageColor: UIColor {
        get { return contentView.imageColor }
        set { contentView.imageColor = newValue }
    }

    open var highlightImageColor: UIColor {
        get { return contentView.highlightImageColor }
        set { contentView.highlightImageColor = newValue }
    }

    open override var image: UIImage? {
        didSet { self.contentView.image = image }
    }

    open override var selectedImage: UIImage? {
        didSet { self.contentView.selectedImage = selectedImage }
    }

    open override var tag: Int {
        didSet { self.contentView.tag = tag }
    }

    let contentView: FluidTabBarItemContentView

    // MARK: Initializers

    public init(
        _ contentView: FluidTabBarItemContentView = FluidTabBarItemContentView(),
        title: String? = nil,
        image: UIImage? = nil,
        selectedImage: UIImage? = nil,
        tag: Int = 0
    ) {
        self.contentView = contentView
        super.init()
        self.setTitle(title, image: image, selectedImage: selectedImage, tag: tag)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public methods

    open func setTitle(
        _ title: String? = nil,
        image: UIImage? = nil,
        selectedImage: UIImage? = nil,
        tag: Int = 0
    ) {
        self.title = title
        self.image = image
        self.selectedImage = selectedImage
        self.tag = tag
    }
}
