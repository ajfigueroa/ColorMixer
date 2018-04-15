//
//  ColorMixerUtilities.swift
//  ColorMixer
//
//  Created by Richard Fa on 2018-01-21.
//

import UIKit

enum Direction {
    case up
    case down
    case left
    case right
}

class TriangleView : UIView {

    var color: UIColor? {
        didSet {
            layer.setNeedsDisplay()
        }
    }

    var direction: Direction? {
        didSet {
            layer.setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(),
            let color = color,
            let direction = direction else {
            return
        }

        context.beginPath()
        switch direction {
        case .up:
            context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
            context.closePath()
            break
        case .down:
            context.move(to: CGPoint(x: rect.minX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.maxY))
            context.closePath()
            break
        case .left:
            context.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.minX, y: (rect.maxY / 2.0)))
            context.closePath()
            break
        case .right:
            context.move(to: CGPoint(x: rect.minX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.maxX, y: (rect.maxY / 2.0)))
            context.closePath()
            break
        }
        context.closePath()
        context.setFillColor(color.cgColor)
        context.fillPath()
    }
}

extension UIColor {

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

extension String {

    func toColor() -> UIColor? {
        guard isHexString() else {
            return nil
        }

        let string = replacingOccurrences(of: "#", with: "").uppercased()
        var red: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var green: CGFloat = 0.0
        var rgb: UInt32 = 0

        guard Scanner(string: string).scanHexInt32(&rgb) else {
            return nil
        }

        red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        blue = CGFloat(rgb & 0x0000FF) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

    func isHexString(isComplete: Bool = true) -> Bool {
        guard self.first == "#" else {
            return false
        }
        let hexString = dropFirst()
        guard (isComplete && hexString.count == 6) || (!isComplete && hexString.count <= 6) else {
            return false
        }
        let validCharacters = CharacterSet(charactersIn: "0123456789ABCDEF")
        return hexString.rangeOfCharacter(from: validCharacters.inverted) == nil
    }
}

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

extension UIImage {
    static func image(from layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.isOpaque, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: context)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage
    }
}

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

extension String {

    func containsColor(names: [String]) -> Bool {
        for name in names {
            if self == name || hasPrefix("\(name) ") || hasSuffix(" \(name)") || range(of: " \(name) ", options: .caseInsensitive) != nil {
                return true
            }
        }
        return false
    }
}
