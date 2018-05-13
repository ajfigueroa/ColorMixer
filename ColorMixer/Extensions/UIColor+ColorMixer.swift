//
//  UIColor+ColorMixer.swift
//  ColorMixer
//
//  Created by Richard Fa on 2018-05-12.
//

import UIKit

extension UIColor {

    static func mixColor(color1: UIColor, with color2: UIColor, atRatio percentage: CGFloat = 0.5) -> UIColor {
        var red1: CGFloat = 0.0
        var green1: CGFloat = 0.0
        var blue1: CGFloat = 0.0
        color1.getRed(&red1, green: &green1, blue: &blue1, alpha: nil)
        var red2: CGFloat = 0.0
        var green2: CGFloat = 0.0
        var blue2: CGFloat = 0.0
        color2.getRed(&red2, green: &green2, blue: &blue2, alpha: nil)

        let red: CGFloat = (red1 * CGFloat(1 - percentage)) + (red2 * CGFloat(percentage))
        let green: CGFloat = (green1 * CGFloat(1 - percentage)) + (green2 * CGFloat(percentage))
        let blue: CGFloat = (blue1 * CGFloat(1 - percentage)) + (blue2 * CGFloat(percentage))
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

    var hue: CGFloat {
        var hue: CGFloat = 0
        self.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        return hue
    }

    func similarity(to color: UIColor) -> CGFloat {
        var red1: CGFloat = 0.0
        var green1: CGFloat = 0.0
        var blue1: CGFloat = 0.0
        getRed(&red1, green: &green1, blue: &blue1, alpha: nil)
        var red2: CGFloat = 0.0
        var green2: CGFloat = 0.0
        var blue2: CGFloat = 0.0
        color.getRed(&red2, green: &green2, blue: &blue2, alpha: nil)

        let redValue: CGFloat = abs(red1 - red2) * 299
        let greenValue: CGFloat = abs(green1 - green2) * 587
        let blueValue: CGFloat = abs(blue1 - blue2) * 114
        return (redValue + greenValue + blueValue) / (299 + 587 + 144)
    }

    func closestColor(of colors: [UIColor]) -> Int {
        var closestIndex: Int = 0
        for color in colors {
            if similarity(to: color) < similarity(to: colors[closestIndex]) {
                if let newColorIndex = colors.index(of: color) {
                    closestIndex = newColorIndex
                }
            }
        }
        return closestIndex
    }

    func closestColor(of colorInfos: [ColorInfo]) -> Int {
        var allColors = [UIColor]()
        for colorInfo in colorInfos {
            allColors.append(colorInfo.color)
        }
        return closestColor(of: allColors)
    }

    func toHexString() -> String {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return String(format: "#%02lX%02lX%02lX", lroundf(Float(red * 255)), lroundf(Float(green * 255)), lroundf(Float(blue * 255)))
    }

    func brightness() -> CGFloat {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return ((red * 299) + (green * 587) + (blue * 114)) / 1000
    }
}

