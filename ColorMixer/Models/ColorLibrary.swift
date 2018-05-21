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
    case segmentThenBrightness
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
        case .segmentThenBrightness:
            return colors.sorted(by: { (colorA, colorB) -> Bool in
                let segmentColors = ColorLibrary.segments
                let segmentColorIndexA = colorA.closestColor(of: segmentColors)
                let segmentColorIndexB = colorB.closestColor(of: segmentColors)
                if segmentColorIndexA != segmentColorIndexB {
                    return segmentColorIndexA < segmentColorIndexB
                }
                let orderedIfAscending = colorA.color.brightness() > colorB.color.brightness()
                return ascending ? orderedIfAscending : !orderedIfAscending
            })
        }
    }

    static func downloadFromServer(withCompletion completion: ((Bool) -> Void)? = nil) {
        let session = URLSession(configuration: .default)
        guard let url = URL(string: "https://raw.githubusercontent.com/rysfa/ColorMixer/master/ColorMixer/colorlibrary.json") else {
            completion?(false)
            return
        }
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data else {
                completion?(false)
                return
            }

            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                completion?(false)
                return
            }

            guard let jsonColors = json!["colors"] as? [Any] else {
                completion?(false)
                return
            }

            var downloadedColors = [ColorInfo]()
            for jsonColor in jsonColors {
                guard let jsonColor = jsonColor as? [String : Any] else {
                    completion?(false)
                    return
                }
                let color = ColorInfo(json: jsonColor)
                downloadedColors.append(color)
            }

            ColorLibrary.colors = downloadedColors

            guard let jsonSegments = json!["segments"] as? [Any] else {
                completion?(false)
                return
            }

            var downloadedSegments = [ColorInfo]()
            for jsonSegment in jsonSegments {
                guard let jsonSegment = jsonSegment as? [String : Any] else {
                    completion?(false)
                    return
                }
                let segment = ColorInfo(json: jsonSegment)
                downloadedSegments.append(segment)
            }

            ColorLibrary.segments = downloadedSegments
            completion?(true)
            }
        dataTask.resume()
    }

    private static var colors = [
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
        ColorInfo(color: .brown, name: "Brown")
        ]

    private static var segments = [
        ColorInfo(color: .red),
        ColorInfo(color: .orange),
        ColorInfo(color: .yellow),
        ColorInfo(color: .green),
        ColorInfo(color: .blue),
        ColorInfo(color: .purple),
        ColorInfo(color: .brown),
        ColorInfo(color: .white),
        ColorInfo(color: .gray),
        ColorInfo(color: .black)
        ]
}
