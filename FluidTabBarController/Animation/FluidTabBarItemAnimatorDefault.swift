//
//  FluidTabBarItemAnimatorDefault.swift
//  FluidTabBarController
//
//  Created by Hubert Kuczyński on 19/07/2018.
//  Copyright © 2018 10Clouds Sp. z o.o. All rights reserved.
//

import UIKit

final class FluidTabBarItemAnimatorDefault: NSObject, FluidTabBarItemAnimator {

    private struct Constants {
        static let scaleDuration = 0.95
        static let positionDuration = 0.2
    }

    // MARK: Public properties

    var allowsLandscapeIconsArrangement: Bool {
        return false
    }

    weak var contentView: FluidTabBarItemContentView?

    // MARK: Private properties

    private lazy var containerAnimator: ContainerAnimator? = {
        guard let contentView = contentView else { return nil }
        let animator = ContainerAnimator(layer: contentView.imageViewContainer.layer)

        animator.onMoveUpAnimationStart = { [weak self] in
            self?.circleLayer.animateMovement()
        }
        animator.onMoveDownAnimationStart = { [weak self] in
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                self?.circleLayer.animateMovement()
            }
        }

        return animator
    }()

    private lazy var labelAnimator: LabelAnimator? = {
        guard let contentView = contentView else { return nil }
        return LabelAnimator(layer: contentView.titleLabel.layer)
    }()

    private lazy var iconAnimator: IconAnimator? = {
        guard let contentView = contentView else { return nil }
        return IconAnimator(layer: contentView.titleLabel.layer)
    }()

    private var circleFillColor: UIColor? {
        return contentView?.tintColor
    }

    private var imageViewAnimationOffset: CGFloat = 0

    private var circleRect: CGRect {
        let inset: CGFloat = -10
        return contentView?.imageViewContainer.bounds.insetBy(dx: inset, dy: inset) ?? .zero
    }

    private lazy var titleLabelAnimationOffset: CGFloat = 60
    private let circleCenterOffset: CGFloat = 5
    private let curveLayer = CurveLayer()

    private lazy var circleLayer: StretchyCircleLayer = {
        let layer = StretchyCircleLayer()
        layer.movementDuration = Constants.scaleDuration / 6
        return layer
    }()

    // MARK: Public methods

    func initialize() {
        guard let contentView = contentView else { return }
        contentView.imageViewContainer.layer.position.y = contentView.center.y
        contentView.titleLabel.layer.position.y = calculateLabelPosition(forStateSelected: false)
        contentView.highlightImageColor = .white
        contentView.imageViewContainer.layer.insertSublayer(circleLayer, at: 0)
        contentView.layer.insertSublayer(curveLayer, at: 0)
        imageViewAnimationOffset = contentView.imageViewContainer.frame.midY - contentView.frame.minY + circleCenterOffset
    }

    func selectAnimation(animated: Bool, completion: (() -> ())?) {
        guard contentView?.frame != .zero else { return }
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        CATransaction.setDisableActions(!animated)
        drawCircle(inRect: circleRect)
        drawCurve(inRect: circleRect)
        animateMoveUp()
        CATransaction.commit()
    }

    func deselectAnimation(animated: Bool, completion: (() -> ())?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        CATransaction.setDisableActions(!animated)
        animateMoveDown()
        CATransaction.commit()
    }

    // MARK: Private methods

    private func animateMoveUp() {
        let time = CACurrentMediaTime()
        let positionAnimationBeginTime = time + Constants.scaleDuration / 2

        curveLayer.animateShow(
            beginTime: positionAnimationBeginTime,
            duration: Constants.scaleDuration / 2
        )

        circleLayer.animateShow(
            beginTime: time,
            duration: Constants.scaleDuration
        )

        containerAnimator?.animateMoveUp(
            offset: -imageViewAnimationOffset,
            beginTime: positionAnimationBeginTime,
            duration: Constants.scaleDuration / 2
        )

        labelAnimator?.animatePosition(
            beginTime: time + Constants.scaleDuration - 0.3,
            duration: Constants.positionDuration,
            toValue: calculateLabelPosition(forStateSelected: true)
        )

        iconAnimator?.animateScale(
            beginTime: time,
            duration: Constants.scaleDuration,
            reversed: false
        )
    }

    private func animateMoveDown() {
        let time = CACurrentMediaTime()

        curveLayer.animateHide(
            beginTime: time,
            duration: Constants.scaleDuration / 2
        )

        circleLayer.animateHide(
            beginTime: time,
            duration: Constants.scaleDuration
        )

        containerAnimator?.animateMoveDown(
            offset: imageViewAnimationOffset,
            beginTime: time + Constants.scaleDuration / 30.0,
            duration: Constants.scaleDuration / 2
        )

        labelAnimator?.animatePosition(
            beginTime: time + 0.05,
            duration: Constants.positionDuration,
            toValue: calculateLabelPosition(forStateSelected: false)
        )

        iconAnimator?.animateScale(
            beginTime: time,
            duration: Constants.scaleDuration,
            reversed: true
        )

        contentView?.imageView.tintColor = contentView?.highlightImageColor
        UIView.animate(withDuration: Constants.scaleDuration) {
            self.contentView?.imageView.tintColor = self.contentView?.imageColor
        }
    }

    private func calculateLabelPosition(forStateSelected selected: Bool) -> CGFloat {
        guard let contentView = contentView else { return 0 }
        if selected {
            return circleRect.maxY + (contentView.frame.maxY - circleRect.maxY - imageViewAnimationOffset) / 2.0 + 3
        } else {
            return contentView.frame.height * 2
        }
    }

    private func drawCircle(inRect rect: CGRect) {
        circleLayer.frame = rect
        circleLayer.fillColor = circleFillColor?.cgColor
    }

    private func drawCurve(inRect rect: CGRect) {
        let curveMargin: CGFloat = 2
        let size = CGSize(
            width: circleRect.width * 2,
            height: circleRect.height / 2 + circleCenterOffset + curveMargin
        )

        curveLayer.frame.size = size
        curveLayer.fillColor = contentView?.backgroundColor?.cgColor ?? UIColor.white.cgColor
        curveLayer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        curveLayer.position = CGPoint(x: contentView!.frame.midX, y: contentView!.frame.minY - 1)
        curveLayer.updatePath(centerOffset: -circleCenterOffset)
    }
}
