//
//  StretchyCircleLayer.swift
//  FluidTabBarController
//
//  Created by Hubert Kuczyński on 12/07/2018.
//  Copyright © 2018 10Clouds Sp. z o.o. All rights reserved.
//

import UIKit

final class StretchyCircleLayer: CAShapeLayer {

    // MARK: Public properties

    override var frame: CGRect {
        didSet {
            path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        }
    }

    var movementDuration: CFTimeInterval = 2.5

    // MARK: Private properties

    private var radius: CGFloat {
        return bounds.size.width / 2.0
    }

    private var yOffsetMax: CGFloat {
        return bounds.size.width * 1.3
    }

    private var displayLink: CADisplayLink?
    private var startTime: CFAbsoluteTime?

    private let yOffset: CGFloat = 30.0

    private let timingFunctions: [CAMediaTimingFunction] = [
        TimingFunctions.values[0],
        TimingFunctions.values[2],
        TimingFunctions.values[1],
        TimingFunctions.values[1],
        TimingFunctions.values[1]
    ]

    // MARK: Public functions

    func animateShow(beginTime: CFTimeInterval, duration: CFTimeInterval) {
        removeAllAnimations()
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.values = [0.0, 1.0, 23.0 / 52.0, 57.0 / 52.0, 49.0 / 52.0, 1.0]
        scaleAnimation.keyTimes = [0, 7.0 / 24.0, 11.0 / 24.0, 18.0 / 24.0, 21.0 / 24.0, 1.0].map { NSNumber(value: $0) }
        scaleAnimation.duration = duration
        scaleAnimation.beginTime = beginTime
        scaleAnimation.timingFunctions = timingFunctions
        add(scaleAnimation, forKey: "show")
    }

    func animateHide(beginTime: CFTimeInterval, duration: CFTimeInterval) {
        removeAllAnimations()
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.values = [1.0, 49.0 / 52.0, 59.0 / 52.0, 18.0 / 52.0, 1.0, 0.0]
        scaleAnimation.keyTimes = [0, 6.0 / 60.0, 12.0 / 60.0, 37.0 / 60.0, 47.0 / 60.0, 1].map { NSNumber(value: $0) }
        scaleAnimation.duration = duration
        scaleAnimation.beginTime = beginTime
        scaleAnimation.fillMode = kCAFillModeForwards
        scaleAnimation.isRemovedOnCompletion = false
        scaleAnimation.timingFunctions = timingFunctions
        add(scaleAnimation, forKey: "hide")
    }

    func animateMovement() {
        displayLink = CADisplayLink(target: self, selector: #selector(handleMovement(displayLink:)))
        startTime = CFAbsoluteTimeGetCurrent()
        displayLink?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    }

    // MARK: Private functions

    private func invalidateDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc private func handleMovement(displayLink: CADisplayLink) {
        guard let startTime = startTime else {
            invalidateDisplayLink()
            return
        }
        let percent = CGFloat(CFAbsoluteTimeGetCurrent() - startTime) / CGFloat(movementDuration)
        if percent < 1.0 {
            let offset = yOffset * sin(percent * CGFloat.pi)
            updatePath(withOffset: offset)
        } else {
            updatePath(withOffset: 0)
            invalidateDisplayLink()
        }
    }

    private func updatePath(withOffset offset: CGFloat) {
        let pullDownCenter = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.width / 2.0)
        path = stretchyCirclePathWithCenter(center: pullDownCenter, radius: radius, yOffset: offset).cgPath
    }

    private func stretchyCirclePathWithCenter(center: CGPoint, radius: CGFloat, yOffset: CGFloat = 0.0) -> UIBezierPath {
        guard yOffset != 0 else {
             return UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2.0 * CGFloat.pi, clockwise: true)
        }

        let lowerRadius = radius * (1 - yOffset / yOffsetMax)
        let yOffsetTop = yOffset / 4
        let yOffsetBottom = yOffset / 2.5
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat.pi, endAngle: 0, clockwise: true)

        path.addCurve(
            to: CGPoint(
                x: center.x + lowerRadius,
                y: center.y + yOffset
            ),
            controlPoint1: CGPoint(
                x: center.x + radius,
                y: center.y + yOffsetTop
            ),
            controlPoint2: CGPoint(
                x: center.x + lowerRadius,
                y: center.y + yOffset - yOffsetBottom
            )
        )
        path.addArc(
            withCenter: CGPoint(
                x: center.x,
                y: center.y + yOffset
            ),
            radius: lowerRadius,
            startAngle: 0,
            endAngle: CGFloat.pi,
            clockwise: true
        )
        path.addCurve(
            to: CGPoint(
                x: center.x - radius,
                y: center.y
            ),
            controlPoint1: CGPoint(
                x: center.x - lowerRadius,
                y: center.y + yOffset - yOffsetBottom
            ),
            controlPoint2: CGPoint(
                x: center.x - radius,
                y: center.y + yOffsetTop
            )
        )
        return path
    }
}
