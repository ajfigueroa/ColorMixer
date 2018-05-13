//
//  UISlider+ColorMixer.swift
//  ColorMixer
//
//  Created by Richard Fa on 2018-05-12.
//

import UIKit

extension UISlider {

    func setGradientBackground(with mainColor: UIColor, with secondaryColor: UIColor) {
        let trackGradientLayer = CAGradientLayer()
        let newFrame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: 3.0)
        trackGradientLayer.frame = newFrame
        trackGradientLayer.colors = [mainColor.cgColor, secondaryColor.cgColor]
        trackGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        trackGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        let trackImage = UIImage.image(from: trackGradientLayer)?.resizableImage(withCapInsets: .zero)
        setMinimumTrackImage(trackImage, for: .normal)
        setMaximumTrackImage(trackImage, for: .normal)
    }
}

