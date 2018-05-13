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
