//
//  ColorLibrary.swift
//  ColorMixer
//
//  Created by Richard on 2018-04-15.
//
//

import UIKit

enum SortColorsBy {
    case segment
    case brightness
    case hue
}

class ColorLibrary {

    static func colors(sorted sortedBy: SortColorsBy, ascending: Bool = true) -> [ColorInfo] {
        switch sortedBy {
        case .segment:
            return colors.sorted(by: { (colorA, colorB) -> Bool in
                let segmentColors = ColorLibrary.segments
                let segmentColorIndexA = colorA.closestColor(of: segmentColors)
                let segmentColorIndexB = colorB.closestColor(of: segmentColors)
                if segmentColorIndexA != segmentColorIndexB {
                    return segmentColorIndexA < segmentColorIndexB
                }
                if segmentColorIndexA == 0 {
                    return colorA.color.similarity(to: segmentColors[1].color) > colorB.color.similarity(to: segmentColors[1].color)
                }
                if segmentColorIndexA == segmentColors.count - 1 {
                    return colorA.color.similarity(to: segmentColors[segmentColors.count - 2].color) < colorB.color.similarity(to: segmentColors[segmentColors.count - 2].color)
                }
                let leftSimilarityA = -colorA.color.similarity(to: segmentColors[segmentColorIndexA - 1].color)
                let leftSimilarityB = -colorB.color.similarity(to: segmentColors[segmentColorIndexA - 1].color)
                let rightSimilarityA = colorA.color.similarity(to: segmentColors[segmentColorIndexA + 1].color)
                let rightSimilarityB = colorB.color.similarity(to: segmentColors[segmentColorIndexA + 1].color)
                let similarityA = abs(leftSimilarityA) < abs(rightSimilarityA) ? leftSimilarityA : rightSimilarityA
                let similarityB = abs(leftSimilarityB) < abs(rightSimilarityB) ? leftSimilarityB : rightSimilarityB
                let orderedIfAscending = similarityA < similarityB
                return ascending ? orderedIfAscending : !orderedIfAscending
            })
        case .brightness:
            return colors.sorted(by: { (colorA, colorB) -> Bool in
                let orderedIfAscending = colorA.color.brightness() > colorB.color.brightness()
                return ascending ? orderedIfAscending : !orderedIfAscending
            })
        case .hue:
            return colors.sorted(by: { (colorA, colorB) -> Bool in
                let orderedIfAscending = colorA.color.hue > colorB.color.hue
                return ascending ? orderedIfAscending : !orderedIfAscending
            })
        }
    }

    private static let colors = [
        ColorInfo(color: .black, name: "Black"),
        ColorInfo(color: .darkGray, name: "Dark Gray"),
        ColorInfo(color: .lightGray, name: "Light Gray"),
        ColorInfo(color: .white, name: "White"),
        ColorInfo(color: .gray, name: "Gray"),
        ColorInfo(color: .red, name: "Red"),
        ColorInfo(color: .green, name: "Green"),
        ColorInfo(color: .blue, name: "Blue"),
        ColorInfo(color: .cyan, name: "Cyan"),
        ColorInfo(color: .yellow, name: "Yellow"),
        ColorInfo(color: .magenta, name: "Magenta"),
        ColorInfo(color: .orange, name: "Orange"),
        ColorInfo(color: .purple, name: "Purple"),
        ColorInfo(color: .brown, name: "Brown"),
        ColorInfo(color: "#F0F8FF".toColor()!, name: "Alice Blue"),
        ColorInfo(color: "#FAEBD7".toColor()!, name: "Antique White"),
        ColorInfo(color: "#7FFFD4".toColor()!, name: "Aquamarine"),
        ColorInfo(color: "#F0FFFF".toColor()!, name: "Azure"),
        ColorInfo(color: "#F5F5DC".toColor()!, name: "Beige"),
        ColorInfo(color: "#FFE4C4".toColor()!, name: "Bisque"),
        ColorInfo(color: "#FFEBCD".toColor()!, name: "Blanched Almond"),
        ColorInfo(color: "#8A2BE2".toColor()!, name: "Blue Violet"),
        ColorInfo(color: "#DEB887".toColor()!, name: "Burlywood"),
        ColorInfo(color: "#5F9EA0".toColor()!, name: "Cadet Blue"),
        ColorInfo(color: "#7FFF00".toColor()!, name: "Chartreuse"),
        ColorInfo(color: "#D2691E".toColor()!, name: "Chocolate"),
        ColorInfo(color: "#FF7F50".toColor()!, name: "Coral"),
        ColorInfo(color: "#6495ED".toColor()!, name: "Cornflower Blue"),
        ColorInfo(color: "#FFF8DC".toColor()!, name: "Cornsilk"),
        ColorInfo(color: "#B8860B".toColor()!, name: "Dark Goldenrod"),
        ColorInfo(color: "#006400".toColor()!, name: "Dark Green"),
        ColorInfo(color: "#BDB76B".toColor()!, name: "Dark Khaki"),
        ColorInfo(color: "#556B2F".toColor()!, name: "Dark Olive Green"),
        ColorInfo(color: "#FF8C00".toColor()!, name: "Dark Orange"),
        ColorInfo(color: "#9932CC".toColor()!, name: "Dark Orchid"),
        ColorInfo(color: "#E9967A".toColor()!, name: "Dark Salmon"),
        ColorInfo(color: "#8FBC8F".toColor()!, name: "Dark Sea Green"),
        ColorInfo(color: "#483D8B".toColor()!, name: "Dark Slate Blue"),
        ColorInfo(color: "#2F4F4F".toColor()!, name: "Dark Slate Gray"),
        ColorInfo(color: "#00CED1".toColor()!, name: "Dark Turquoise"),
        ColorInfo(color: "#9400D3".toColor()!, name: "Dark Violet"),
        ColorInfo(color: "#FF1493".toColor()!, name: "Deep Pink"),
        ColorInfo(color: "#00BFFF".toColor()!, name: "Deep Sky Blue"),
        ColorInfo(color: "#696969".toColor()!, name: "Dim Gray"),
        ColorInfo(color: "#1E90FF".toColor()!, name: "Dodger Blue"),
        ColorInfo(color: "#B22222".toColor()!, name: "Fire Brick"),
        ColorInfo(color: "#FFFAF0".toColor()!, name: "Floral White"),
        ColorInfo(color: "#228B22".toColor()!, name: "Forest Green"),
        ColorInfo(color: "#DCDCDC".toColor()!, name: "Gainsboro"),
        ColorInfo(color: "#F8F8FF".toColor()!, name: "Ghost White"),
        ColorInfo(color: "#FFD700".toColor()!, name: "Gold"),
        ColorInfo(color: "#DAA520".toColor()!, name: "Goldenrod"),
        ColorInfo(color: "#ADFF2F".toColor()!, name: "Green Yellow"),
        ColorInfo(color: "#F0FFF0".toColor()!, name: "Honeydew"),
        ColorInfo(color: "#FF69B4".toColor()!, name: "Hot Pink"),
        ColorInfo(color: "#CD5C5C".toColor()!, name: "Indian Red"),
        ColorInfo(color: "#FFFFF0".toColor()!, name: "Ivory"),
        ColorInfo(color: "#F0E68C".toColor()!, name: "Khaki"),
        ColorInfo(color: "#E6E6FA".toColor()!, name: "Lavender"),
        ColorInfo(color: "#FFF0F5".toColor()!, name: "Lavender Blush"),
        ColorInfo(color: "#7CFC00".toColor()!, name: "Lawn Green"),
        ColorInfo(color: "#FFFACD".toColor()!, name: "Lemon Chiffon"),
        ColorInfo(color: "#EEDD82".toColor()!, name: "Light"),
        ColorInfo(color: "#ADD8E6".toColor()!, name: "Light Blue"),
        ColorInfo(color: "#F08080".toColor()!, name: "Light Coral"),
        ColorInfo(color: "#E0FFFF".toColor()!, name: "Light Cyan"),
        ColorInfo(color: "#FFEC8B".toColor()!, name: "Light Goldenrod"),
        ColorInfo(color: "#FAFAD2".toColor()!, name: "Light Goldenrod Yellow"),
        ColorInfo(color: "#FFB6C1".toColor()!, name: "Light Pink"),
        ColorInfo(color: "#FFA07A".toColor()!, name: "Light Salmon"),
        ColorInfo(color: "#20B2AA".toColor()!, name: "Light Sea Green"),
        ColorInfo(color: "#87CEFA".toColor()!, name: "Light Sky Blue"),
        ColorInfo(color: "#8470FF".toColor()!, name: "Light Slate Blue"),
        ColorInfo(color: "#778899".toColor()!, name: "Light Slate Gray"),
        ColorInfo(color: "#B0C4DE".toColor()!, name: "Light Steel Blue"),
        ColorInfo(color: "#FFFFE0".toColor()!, name: "Light Yellow"),
        ColorInfo(color: "#32CD32".toColor()!, name: "Lime Green"),
        ColorInfo(color: "#FAF0E6".toColor()!, name: "Linen"),
        ColorInfo(color: "#B03060".toColor()!, name: "Maroon"),
        ColorInfo(color: "#66CDAA".toColor()!, name: "Medium Aquamarine"),
        ColorInfo(color: "#0000CD".toColor()!, name: "Medium Blue"),
        ColorInfo(color: "#BA55D3".toColor()!, name: "Medium Orchid"),
        ColorInfo(color: "#9370DB".toColor()!, name: "Medium Purple"),
        ColorInfo(color: "#3CB371".toColor()!, name: "Medium Sea Green"),
        ColorInfo(color: "#7B68EE".toColor()!, name: "Medium Slate Blue"),
        ColorInfo(color: "#00FA9A".toColor()!, name: "Medium Spring Green"),
        ColorInfo(color: "#48D1CC".toColor()!, name: "Medium Turquoise"),
        ColorInfo(color: "#C71585".toColor()!, name: "Medium Violet Red"),
        ColorInfo(color: "#191970".toColor()!, name: "Midnight Blue"),
        ColorInfo(color: "#F5FFFA".toColor()!, name: "Mint Cream"),
        ColorInfo(color: "#FFE4E1".toColor()!, name: "Misty Rose"),
        ColorInfo(color: "#FFE4B5".toColor()!, name: "Moccasin"),
        ColorInfo(color: "#FFDEAD".toColor()!, name: "Navajo White"),
        ColorInfo(color: "#000080".toColor()!, name: "Navy Blue"),
        ColorInfo(color: "#FDF5E6".toColor()!, name: "Old Lace"),
        ColorInfo(color: "#6B8E23".toColor()!, name: "Olive Drab"),
        ColorInfo(color: "#FF4500".toColor()!, name: "Orange Red"),
        ColorInfo(color: "#DA70D6".toColor()!, name: "Orchid"),
        ColorInfo(color: "#DB7093".toColor()!, name: "Pale Violet Red"),
        ColorInfo(color: "#EEE8AA".toColor()!, name: "Pale Goldenrod"),
        ColorInfo(color: "#98FB98".toColor()!, name: "Pale Green"),
        ColorInfo(color: "#AFEEEE".toColor()!, name: "Pale Turquoise"),
        ColorInfo(color: "#FFEFD5".toColor()!, name: "Papaya Whip"),
        ColorInfo(color: "#FFDAB9".toColor()!, name: "Peach Puff"),
        ColorInfo(color: "#FFC0CB".toColor()!, name: "Pink"),
        ColorInfo(color: "#DDA0DD".toColor()!, name: "Plum"),
        ColorInfo(color: "#B0E0E6".toColor()!, name: "Powder Blue"),
        ColorInfo(color: "#663399".toColor()!, name: "Rebecca Purple"),
        ColorInfo(color: "#BC8F8F".toColor()!, name: "Rosy Brown"),
        ColorInfo(color: "#4169E1".toColor()!, name: "Royal Blue"),
        ColorInfo(color: "#8B4513".toColor()!, name: "Saddle Brown"),
        ColorInfo(color: "#FA8072".toColor()!, name: "Salmon"),
        ColorInfo(color: "#F4A460".toColor()!, name: "Sandy Brown"),
        ColorInfo(color: "#54FF9F".toColor()!, name: "Sea Green"),
        ColorInfo(color: "#FFF5EE".toColor()!, name: "Seashell"),
        ColorInfo(color: "#A0522D".toColor()!, name: "Sienna"),
        ColorInfo(color: "#87CEEB".toColor()!, name: "Sky Blue"),
        ColorInfo(color: "#6A5ACD".toColor()!, name: "Slate Blue"),
        ColorInfo(color: "#708090".toColor()!, name: "Slate Gray"),
        ColorInfo(color: "#FFFAFA".toColor()!, name: "Snow"),
        ColorInfo(color: "#00FF7F".toColor()!, name: "Spring Green"),
        ColorInfo(color: "#4682B4".toColor()!, name: "Steel Blue"),
        ColorInfo(color: "#D2B48C".toColor()!, name: "Tan"),
        ColorInfo(color: "#D8BFD8".toColor()!, name: "Thistle"),
        ColorInfo(color: "#FF6347".toColor()!, name: "Tomato"),
        ColorInfo(color: "#40E0D0".toColor()!, name: "Turquoise"),
        ColorInfo(color: "#EE82EE".toColor()!, name: "Violet"),
        ColorInfo(color: "#D02090".toColor()!, name: "Violet Red"),
        ColorInfo(color: "#F5DEB3".toColor()!, name: "Wheat"),
        ColorInfo(color: "#F5F5F5".toColor()!, name: "White Smoke"),
        ColorInfo(color: "#9ACD32".toColor()!, name: "Yellow Green"),
        ]

    private static let segments = [
        ColorInfo(color: .red, name: "Red", altNames: ["Pink"]),
        ColorInfo(color: .orange, name: "Orange", altNames: ["Coral", "Salmon"]),
        ColorInfo(color: .yellow, name: "Yellow", altNames: ["Gold", "Goldenrod"]),
        ColorInfo(color: .green, name: "Green", altNames: ["Olive", "Turquoise"]),
        ColorInfo(color: .blue, name: "Blue", altNames: ["Aquamarine", "Cyan"]),
        ColorInfo(color: .purple, name: "Purple", altNames: ["Violet", "Orchid", "Lavender"]),
        ColorInfo(color: .brown, name: "Brown", altNames: ["Khaki", "Tan"]),
        ColorInfo(color: .white, name: "White"),
        ColorInfo(color: .gray, name: "Gray"),
        ColorInfo(color: .black, name: "Black"),
        ]
}
