//
//  FluidTabBarItem.swift
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
