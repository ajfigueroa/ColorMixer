//
//  CAAnimation+ColorMixer.swift
//  ColorMixer
//
//  Created by Richard Fa on 2018-05-12.
//

import UIKit

let kColorBottomRotationKey = "kColorBottomRotationKey"
let kColorTopRotationKey = "kColorTopRotationKey"
let kColorRotationDuration: CFTimeInterval = 0.35

let kSpinKey = "kSpinKey"
let kSpinDuration: CFTimeInterval = 1.4

var shouldStopSpinAnimation = false

extension CAAnimation {

    private static let fakeBottomColorView = UIView()
    private static let fakeTopColorView = UIView()

    static func rotate(topColorView: UIView, bottomColorView: UIView,
                       fromTopColor: UIColor?, fromBottomColor: UIColor?,
                       toTopColor: UIColor, toBottomColor: UIColor,
                       completion:(() -> Void)?) -> Bool {

        if fakeTopColorView.superview == nil || fakeBottomColorView.superview == nil {
            guard let superview = topColorView.superview else {
                return false
            }
            superview.insertSubview(fakeBottomColorView, belowSubview: topColorView)
            superview.insertSubview(fakeTopColorView, belowSubview: topColorView)
        }

        let anchorPoint = CGPoint(x: topColorView.center.x, y: topColorView.frame.maxY)

        let radius: CGFloat = floor(topColorView.bounds.width / 2.0)

        fakeBottomColorView.frame = bottomColorView.frame
        fakeBottomColorView.layer.anchorPoint = CGPoint(x: (anchorPoint.x - fakeBottomColorView.frame.minX) / fakeBottomColorView.frame.width, y: (anchorPoint.y - fakeBottomColorView.frame.minY) / fakeBottomColorView.frame.height)
        fakeBottomColorView.layer.position = anchorPoint
        fakeBottomColorView.round(corners: [.bottomLeft, .bottomRight], with: radius)

        fakeTopColorView.frame = topColorView.frame
        fakeTopColorView.layer.anchorPoint = CGPoint(x: (anchorPoint.x - fakeTopColorView.frame.minX) / fakeTopColorView.frame.width, y: (anchorPoint.y - fakeTopColorView.frame.minY) / fakeTopColorView.frame.height)
        fakeTopColorView.layer.position = anchorPoint
        fakeTopColorView.round(corners: [.topLeft, .topRight], with: radius)

        if fakeBottomColorView.layer.animation(forKey: kColorBottomRotationKey) == nil &&
            fakeTopColorView.layer.animation(forKey: kColorTopRotationKey) == nil {

            let isAnimatingMainColor = fromTopColor != nil
            let isAnimatingSecondaryColor = fromBottomColor != nil

            if isAnimatingMainColor || isAnimatingSecondaryColor {
                fakeTopColorView.isHidden = false
                fakeBottomColorView.isHidden = false

                if isAnimatingMainColor && isAnimatingSecondaryColor {
                    fakeTopColorView.backgroundColor = toBottomColor
                    fakeBottomColorView.backgroundColor = toTopColor
                    topColorView.isHidden = true
                    bottomColorView.isHidden = true
                } else if isAnimatingSecondaryColor {
                    fakeTopColorView.backgroundColor = toBottomColor
                    fakeBottomColorView.backgroundColor = fromBottomColor
                    bottomColorView.isHidden = true
                } else if isAnimatingMainColor {
                    fakeTopColorView.backgroundColor = fromTopColor
                    fakeBottomColorView.backgroundColor = toTopColor
                    topColorView.isHidden = true
                }

                CATransaction.begin()

                let rotation1 = CABasicAnimation(keyPath: "transform.rotation.z")
                rotation1.duration = kColorRotationDuration
                rotation1.fromValue = 0.0
                rotation1.toValue = Double.pi

                let opacity1 = CABasicAnimation(keyPath: "opacity")
                opacity1.duration = kColorRotationDuration
                if isAnimatingSecondaryColor {
                    opacity1.fromValue = bottomColorView.alpha
                    opacity1.toValue = 0.0
                }
                if isAnimatingMainColor {
                    opacity1.fromValue = 0.0
                    opacity1.toValue = topColorView.alpha
                }

                let animations1 = CAAnimationGroup()
                animations1.animations = [rotation1, opacity1]
                animations1.isRemovedOnCompletion = true
                animations1.duration = kColorRotationDuration

                let rotation2 = CABasicAnimation(keyPath: "transform.rotation.z")
                rotation2.duration = kColorRotationDuration
                rotation2.fromValue = 0.0
                rotation2.toValue = Double.pi

                let opacity2 = CABasicAnimation(keyPath: "opacity")
                opacity2.duration = kColorRotationDuration
                if isAnimatingSecondaryColor {
                    opacity2.fromValue = 0.0
                    opacity2.toValue = bottomColorView.alpha
                }
                if isAnimatingMainColor {
                    opacity2.fromValue = topColorView.alpha
                    opacity2.toValue = 0.0
                }

                let animations2 = CAAnimationGroup()
                animations2.animations = [rotation2, opacity2]
                animations2.isRemovedOnCompletion = true
                animations2.duration = kColorRotationDuration

                CATransaction.setCompletionBlock({
                    fakeBottomColorView.isHidden = true
                    fakeTopColorView.isHidden = true
                    topColorView.isHidden = false
                    bottomColorView.isHidden = false

                    completion?()
                })

                fakeBottomColorView.layer.add(animations1, forKey: kColorBottomRotationKey)
                fakeTopColorView.layer.add(animations2, forKey: kColorTopRotationKey)

                CATransaction.commit()
            }
        }
        return true
    }

    static func spin(view: UIView, completion:(() -> Void)?) {

        CATransaction.begin()

        let spinAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        spinAnimation.duration = kSpinDuration
        spinAnimation.fromValue = 0.0
        spinAnimation.toValue = Double.pi * 2
        spinAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        CATransaction.setCompletionBlock({
            if !shouldStopSpinAnimation {
                CATransition.spin(view: view, completion: completion)
            } else {
                completion?()
            }
        })

        view.layer.add(spinAnimation, forKey: kSpinKey)

        CATransaction.commit()
    }
}
