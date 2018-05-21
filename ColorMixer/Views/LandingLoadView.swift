//
//  LandingLoadView.swift
//  ColorMixer
//
//  Created by Richard Fa on 2018-05-21.
//

import UIKit

class LandingLoadView: UIView {

    let imageView = UIImageView(image: UIImage(named: "logo"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        addSubview(imageView)

        translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        addConstraints([NSLayoutConstraint(item: imageView, attribute: .centerX,
                                           relatedBy: .equal, toItem: self,
                                           attribute: .centerX, multiplier: 1.0,
                                           constant: 0.0),
                        NSLayoutConstraint(item: imageView, attribute: .centerY,
                                           relatedBy: .equal, toItem: self,
                                           attribute: .centerY, multiplier: 1.0,
                                           constant: 0.0),
                        NSLayoutConstraint(item: imageView, attribute: .width,
                                           relatedBy: .equal, toItem: self,
                                           attribute: .width, multiplier: 1.0,
                                           constant: 0.0),
                        NSLayoutConstraint(item: imageView, attribute: .height,
                                           relatedBy: .equal, toItem: imageView,
                                           attribute: .width, multiplier: 1.0,
                                           constant: 0.0)])
    }

    func start(with completion:(() -> Void)?) {
        shouldStopSpinAnimation = false
        CATransition.spin(view: imageView, completion: completion)
    }

    func stop() {
        shouldStopSpinAnimation = true
    }
}
