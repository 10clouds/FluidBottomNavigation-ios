//
//  IconAnimator.swift
//  FluidTabBarController
//
//  Created by Hubert Kuczyński on 19/07/2018.
//  Copyright © 2018 10Clouds Sp. z o.o. All rights reserved.
//

import UIKit

final class IconAnimator {

    // MARK: Private properties

    private let layer: CALayer

    // MARK: Initializers

    init(layer: CALayer) {
        self.layer = layer
    }

    // MARK: Public methods

    func animateScale(beginTime: CFTimeInterval, duration: CFTimeInterval, reversed: Bool) {
        let iconScaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        iconScaleAnimation.values = [1.0, 0.94, 1.1, 1.0]
        iconScaleAnimation.keyTimes = [0.0, 4.0 / 15.0, 8.0 / 15.0, 1.0].map { NSNumber(value: $0) }
        iconScaleAnimation.timingFunctions = [
            TimingFunctions.values[3],
            TimingFunctions.values[0],
            TimingFunctions.values[0]
        ]
        iconScaleAnimation.calculationMode = kCAAnimationCubic
        iconScaleAnimation.duration = duration
        iconScaleAnimation.beginTime = beginTime

        if reversed {
            iconScaleAnimation.values?.reverse()
            iconScaleAnimation.keyTimes?.reverse()
            iconScaleAnimation.timingFunctions?.reverse()
        }
        layer.add(iconScaleAnimation, forKey: "scale")
    }
}
