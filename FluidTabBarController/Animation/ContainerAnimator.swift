//
//  ContainerAnimator.swift
//  FluidTabBarController
//
//  Created by Hubert Kuczyński on 19/07/2018.
//  Copyright © 2018 10Clouds Sp. z o.o. All rights reserved.
//

import UIKit

final class ContainerAnimator: NSObject {

    private struct Constants {
        static let positionAnimationDelta: CGFloat = 0.2
        struct Keys {
            static let moveDown = "move_down"
            static let moveUp = "move_up"
        }
    }

    // MARK: Public properties

    var onMoveUpAnimationStart: (() -> Void)?
    var onMoveDownAnimationStart: (() -> Void)?

    // MARK: Private properties

    private let layer: CALayer

    // MARK: Initializers

    init(layer: CALayer) {
        self.layer = layer
        super.init()
    }

    // MARK: Public methods

    func animateMoveDown(offset: CGFloat, beginTime: CFTimeInterval, duration: CFTimeInterval) {
        let positionAnimation = CAKeyframeAnimation(keyPath: "position.y")
        let delta = offset * Constants.positionAnimationDelta

        positionAnimation.values = [layer.position.y, layer.position.y - delta, layer.position.y + offset]
        positionAnimation.keyTimes = [0.0, 1.0 / 4.0, 1.0].map { NSNumber(value: $0) }
        positionAnimation.timingFunctions = [TimingFunctions.values[3], TimingFunctions.values[0]]
        positionAnimation.fillMode = kCAFillModeBackwards
        positionAnimation.beginTime = beginTime
        positionAnimation.duration = duration
        positionAnimation.delegate = self

        layer.add(positionAnimation, forKey: Constants.Keys.moveDown)
        layer.position.y += offset
    }

    func animateMoveUp(offset: CGFloat, beginTime: CFTimeInterval, duration: CFTimeInterval) {
        let positionAnimation = createPositionAnimation(startValue: layer.position.y, endValue: layer.position.y + offset)
        positionAnimation.beginTime = beginTime
        positionAnimation.duration = duration
        positionAnimation.delegate = self
        layer.add(positionAnimation, forKey: Constants.Keys.moveUp)
        layer.position.y += offset
    }

    // MARK: Private methods

    private func createPositionAnimation(startValue: CGFloat, endValue: CGFloat) -> CAAnimation {
        let animation = CAKeyframeAnimation(keyPath: "position.y")
        let delta = (endValue - startValue) * Constants.positionAnimationDelta
        let easeIn = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        let easeOut = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.timingFunctions = [easeOut, easeIn, easeOut]
        animation.values = [startValue, endValue + delta, endValue - delta / 2, endValue]
        animation.fillMode = kCAFillModeBackwards
        return animation
    }
}

extension ContainerAnimator: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        if anim == layer.animation(forKey: Constants.Keys.moveDown) {
            onMoveDownAnimationStart?()
        } else if anim == layer.animation(forKey: Constants.Keys.moveUp) {
            onMoveUpAnimationStart?()
        }
    }
}
