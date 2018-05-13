//
//  ColorMixCollectionViewCell.swift
//  ColorMixer
//
//  Created by Richard Fa on 2018-05-13.
//

import UIKit

class ColorMixCollectionViewCell: UICollectionViewCell {

    @IBOutlet var activeView: TriangleView! {
        didSet {
            activeView.direction = .up
        }
    }

    var color: UIColor = .clear {
        didSet {
            backgroundColor = color
            layer.shadowColor = color == .white ? color.cgColor : color.cgColor
        }
    }

    var active: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.masksToBounds = false
    }
}
