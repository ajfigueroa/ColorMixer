//
//  UIView+ColorMixer.swift
//  ColorMixer
//
//  Created by Richard Fa on 2018-05-12.
//

import UIKit

extension UIView {

    func round(corners: UIRectCorner = .allCorners, with radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

