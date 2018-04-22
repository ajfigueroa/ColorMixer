//
//  ColorSectionBar.swift
//  ColorMixer
//
//  Created by Richard Fa on 2018-04-21.
//

import UIKit

class ColorSectionBar: UIView {

    fileprivate var colorButtons = [UIButton]()

    var colors = [UIColor]() {
        didSet {
            colorButtons.removeAll()
            for i in 0..<colors.count {
                let button = UIButton()
                button.backgroundColor = colors[i]
                colorButtons.append(button)
            }
            setNeedsLayout()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard colorButtons.count > 0 else {
            return
        }
        let sectionWidth: CGFloat = bounds.width / CGFloat(colorButtons.count)
        for i in 0..<colorButtons.count {
            colorButtons[i].frame = CGRect(x: (CGFloat)(i) * sectionWidth,
                                           y: 0.0, width: sectionWidth,
                                           height: bounds.height)
        }
    }
}
