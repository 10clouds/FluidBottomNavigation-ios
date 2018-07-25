//
//  CurveLayer.swift
//  FluidTabBarController
//
//  Created by Hubert Kuczyński on 11/07/2018.
//  Copyright © 2018 10Clouds Sp. z o.o.
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

final class CurveLayer: CAShapeLayer {

    // MARK: Public methods

    func animateShow(beginTime: CFTimeInterval, duration: CFTimeInterval) {
        let curveScaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        curveScaleAnimation.values = [0.0, 1.2, 0.9, 1.0]
        curveScaleAnimation.keyTimes = [0.0, 1.4 / 4.0, 2.9 / 4.0, 1.0].map { NSNumber(value: $0) }
        curveScaleAnimation.beginTime = beginTime
        curveScaleAnimation.duration = duration
        curveScaleAnimation.fillMode = kCAFillModeBackwards
        transform = CATransform3DIdentity
        add(curveScaleAnimation, forKey: "scale_up")
    }

    func animateHide(beginTime: CFTimeInterval, duration: CFTimeInterval) {
        let curveScaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        curveScaleAnimation.values = [1.0, 1.2, 0.0]
        curveScaleAnimation.keyTimes = [0.0, 1.4 / 4.0, 1.0].map { NSNumber(value: $0) }
        curveScaleAnimation.duration = duration
        curveScaleAnimation.fillMode = kCAFillModeBackwards
        transform = CATransform3DMakeScale(0, 0, 0)
        add(curveScaleAnimation, forKey: "scale_down")
    }

    func updatePath(centerOffset: CGFloat) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))

        let topOffset: CGFloat = bounds.width / 3.3
        let bottomOffset: CGFloat = bounds.width / 3.5

        path.addCurve(
            to: CGPoint(x: bounds.midX, y: bounds.minY),
            controlPoint1: CGPoint(x: bounds.minX + bottomOffset, y: bounds.maxY),
            controlPoint2: CGPoint(x: bounds.midX - topOffset, y: bounds.minY)
        )

        path.addCurve(
            to: CGPoint(x: bounds.maxX, y: bounds.maxY),
            controlPoint1: CGPoint(x: bounds.midX + topOffset, y: bounds.minY),
            controlPoint2: CGPoint(x: bounds.maxX - bottomOffset, y: bounds.maxY)
        )

        path.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        self.path = path.cgPath
    }
}
