//
//  FluidTabBarItemAnimator.swift
//  FluidTabBarController
//
//  Created by Hubert Kuczyński on 10/07/2018.
//  Copyright © 2018 10Clouds Sp. z o.o. All rights reserved.
//

import Foundation

public protocol FluidTabBarItemAnimator {
    var allowsLandscapeIconsArrangement: Bool { get }
    func initialize()
    func selectAnimation(animated: Bool, completion: (() -> ())?)
    func deselectAnimation(animated: Bool, completion: (() -> ())?)
    func reselectAnimation(animated: Bool, completion: (() -> ())?)
    func highlightAnimation(animated: Bool, completion: (() -> ())?)
    func dehighlightAnimation(animated: Bool, completion: (() -> ())?)
}

extension FluidTabBarItemAnimator {
    var allowsLandscapeIconsArrangement: Bool {
        return true
    }

    func selectAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }

    func deselectAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }

    func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }

    func highlightAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }

    func dehighlightAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
}
