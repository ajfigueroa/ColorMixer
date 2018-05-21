//
//  ColorSectionBar.swift
//  ColorMixer
//
//  Created by Richard Fa on 2018-04-21.
//

import UIKit

class ColorSectionBar: UIView {

    fileprivate var colors = [CGColor]()

    fileprivate let gradientLayer = CAGradientLayer()

    var colorInfos = [ColorInfo]() {
        didSet {
            colors.removeAll()
            for i in 0..<colorInfos.count {
                colors.append(colorInfos[i].color.cgColor)
            }
            setNeedsLayout()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.colors = colors

        let separation: CGFloat = 1.0 / (CGFloat(colors.count) - 1.0)

        var locations = [NSNumber]()
        for i in 0..<colors.count {
            locations.append(NSNumber(floatLiteral: Double(CGFloat(i) * separation)))
        }

        gradientLayer.locations = locations
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)

        if gradientLayer.superlayer == nil {
            layer.insertSublayer(gradientLayer, at: 0)
        }
        gradientLayer.frame = layer.bounds
    }
}
