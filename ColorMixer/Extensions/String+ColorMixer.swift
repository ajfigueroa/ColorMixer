//
//  String+ColorMixer.swift
//  ColorMixer
//
//  Created by Richard Fa on 2018-05-12.
//

import UIKit

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

    func containsColor(names: [String]) -> Bool {
        for name in names {
            if self == name || hasPrefix("\(name) ") || hasSuffix(" \(name)") || range(of: " \(name) ", options: .caseInsensitive) != nil {
                return true
            }
        }
        return false
    }
}
