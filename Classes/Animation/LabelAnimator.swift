//
//  LabelAnimator.swift
//  FluidTabBarController
//
//  Created by Hubert Kuczyński on 19/07/2018.
//  Copyright © 2018 10Clouds Sp. z o.o. All rights reserved.
//

import UIKit

final class LabelAnimator {

    // MARK: Private properties

    private let layer: CALayer

    // MARK: Initializers

    init(layer: CALayer) {
        self.layer = layer
    }

    // MARK: Public methods

    func animatePosition(beginTime: CFTimeInterval, duration: CFTimeInterval, toValue: CGFloat) {
        let animation = CAKeyframeAnimation(keyPath: "position.y")
        let startValue = layer.position.y
        let easeIn = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        let easeOut = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.timingFunctions = [easeOut, easeIn, easeOut]
        animation.values = [startValue, toValue - toValue * 0.2, toValue + toValue * 0.1, toValue]
        animation.fillMode = kCAFillModeBackwards
        animation.beginTime = beginTime
        animation.duration = duration

        layer.add(animation, forKey: "position.y")
        layer.position.y = toValue
    }
}
