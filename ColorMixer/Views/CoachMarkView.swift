//
//  CoachMarkView.swift
//  ColorMixer
//
//  Created by Richard Fa on 2018-05-18.
//

import UIKit

let kCoachMarkFadeDuration: CFTimeInterval = 0.35

class CoachMarkView: UIVisualEffectView {

    fileprivate var highlightedFeatureView: UIImageView?
    fileprivate var arrowView: TriangleView?

    func show(highlight feature: UIView) -> Bool {
        isHidden = false
        alpha = 0.0
        let canHighlight = highlight(feature: feature)
        if !canHighlight {
            return false
        }
        UIView.animate(withDuration: kCoachMarkFadeDuration, animations: {
            self.alpha = 1.0
        }) { (success: Bool) in
        }
        return true
    }

    func hide() {
        UIView.animate(withDuration: kCoachMarkFadeDuration, animations: {
            self.alpha = 0.0
        }) { (success: Bool) in
            self.highlightedFeatureView?.removeFromSuperview()
            self.arrowView?.removeFromSuperview()
            self.highlightedFeatureView = nil
            self.arrowView = nil
            self.isHidden = true
        }
    }

    fileprivate func highlight(feature: UIView) -> Bool {
        UIGraphicsBeginImageContextWithOptions(feature.bounds.size, feature.isOpaque, 0.0)
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return false
        }
        feature.layer.render(in: currentContext)

        let fakeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        highlightedFeatureView = UIImageView()
        guard let highlightedFeatureView = highlightedFeatureView else {
            return false
        }

        highlightedFeatureView.image = fakeImage
        contentView.addSubview(highlightedFeatureView)
        highlightedFeatureView.frame = contentView.convert(feature.frame, from: feature)

        let featureLocation = highlightedFeatureView.frame.midX < contentView.frame.midX ? Direction.left : Direction.right

        arrowView = TriangleView()
        guard let arrowView = arrowView else {
            return false
        }
        arrowView.color = .white
        arrowView.direction = featureLocation == Direction.left ? Direction.right : Direction.left
        if arrowView.superview == nil {
            contentView.addSubview(arrowView)
        }

        let featureHeight: CGFloat = highlightedFeatureView.frame.height
        let featureMinX: CGFloat = highlightedFeatureView.frame.minX
        let featureMaxX: CGFloat = highlightedFeatureView.frame.maxX
        let featureMinY: CGFloat = highlightedFeatureView.frame.minY

        let arrowWidth: CGFloat = arrowView.frame.width
        let arrowHeight: CGFloat = arrowView.frame.height

        let padding: CGFloat = 5.0
        let arrowMinX: CGFloat = featureLocation == Direction.left ? featureMaxX + padding : featureMinX - arrowWidth - padding
        let arrowMinY: CGFloat = (featureHeight - arrowHeight) / 2 + featureMinY
        arrowView.frame = CGRect(x: arrowMinX, y: arrowMinY, width: arrowWidth, height: arrowHeight)

        return true
    }

}
