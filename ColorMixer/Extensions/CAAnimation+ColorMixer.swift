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

extension CAAnimation {

    static func rotate(mainColorView: UIView, secondaryColorView: UIView,
                       fakeTopColorView: UIView, fakeBottomColorView: UIView,
                       originalMainColor: UIColor?, originalSecondaryColor: UIColor?,
                       mainColor: UIColor, secondaryColor: UIColor,
                       completion:(() -> Void)?) {
        if fakeBottomColorView.layer.animation(forKey: kColorBottomRotationKey) == nil &&
            fakeTopColorView.layer.animation(forKey: kColorTopRotationKey) == nil {

            let isAnimatingMainColor = originalMainColor != nil
            let isAnimatingSecondaryColor = originalSecondaryColor != nil

            if isAnimatingMainColor || isAnimatingSecondaryColor {
                fakeTopColorView.isHidden = false
                fakeBottomColorView.isHidden = false

                if isAnimatingSecondaryColor {
                    fakeTopColorView.backgroundColor = secondaryColor
                    fakeBottomColorView.backgroundColor = originalSecondaryColor
                    secondaryColorView.isHidden = true
                }
                if isAnimatingMainColor {
                    fakeTopColorView.backgroundColor = originalMainColor
                    fakeBottomColorView.backgroundColor = mainColor
                    mainColorView.isHidden = true
                }

                CATransaction.begin()

                let rotation1 = CABasicAnimation(keyPath: "transform.rotation.z")
                rotation1.duration = kColorRotationDuration
                rotation1.fromValue = 0.0
                rotation1.toValue = Double.pi

                let opacity1 = CABasicAnimation(keyPath: "opacity")
                opacity1.duration = kColorRotationDuration
                if isAnimatingSecondaryColor {
                    opacity1.fromValue = secondaryColorView.alpha
                    opacity1.toValue = 0.0
                }
                if isAnimatingMainColor {
                    opacity1.fromValue = 0.0
                    opacity1.toValue = mainColorView.alpha
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
                    opacity2.toValue = secondaryColorView.alpha
                }
                if isAnimatingMainColor {
                    opacity2.fromValue = mainColorView.alpha
                    opacity2.toValue = 0.0
                }

                let animations2 = CAAnimationGroup()
                animations2.animations = [rotation2, opacity2]
                animations2.isRemovedOnCompletion = true
                animations2.duration = kColorRotationDuration

                CATransaction.setCompletionBlock({
                    fakeTopColorView.isHidden = true
                    fakeBottomColorView.isHidden = true
                    mainColorView.isHidden = false
                    secondaryColorView.isHidden = false

                    completion?()
                })

                fakeBottomColorView.layer.add(animations1, forKey: kColorBottomRotationKey)
                fakeTopColorView.layer.add(animations2, forKey: kColorTopRotationKey)

                CATransaction.commit()
            }
        }
    }
}

