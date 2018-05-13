//
//  ColorInfo.swift
//  ColorMixer
//
//  Created by Richard Fa on 2018-05-12.
//

import UIKit

struct ColorInfo {

    var color: UIColor
    var name: String?
    var altNames: [String]?

    init(color color1: UIColor, name name1: String? = nil, altNames altNames1: [String]? = nil) {
        color = color1
        name = name1
        altNames = altNames1
    }

    func closestColor(of colorInfos: [ColorInfo]) -> Int {
        var matchingColorByName = [ColorInfo]()
        for colorInfo in colorInfos {
            var findNames = [String]()
            if let colorInfoName = colorInfo.name {
                findNames.append(colorInfoName)
            }
            if let colorInfoAltNames = colorInfo.altNames {
                findNames.append(contentsOf: colorInfoAltNames)
            }
            if let name = name {
                if name.containsColor(names: findNames) {
                    matchingColorByName.append(colorInfo)
                }
            }
        }

        if matchingColorByName.count > 0 {
            let bestColor = matchingColorByName[color.closestColor(of: matchingColorByName)]
            return bestColor.color.closestColor(of: colorInfos)
        }

        return color.closestColor(of: colorInfos)
    }
}
