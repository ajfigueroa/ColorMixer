//
//  ColorMixViewController.swift
//  ColorMixer
//
//  Created by Richard Fa on 2018-01-20.
//

import UIKit

class ColorMixViewController: UIViewController {

    static var secondaryColors: [ColorInfo] = {

        return ColorLibrary.colors.sorted(by: { (colorA, colorB) -> Bool in
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
            return similarityA < similarityB
        })
    }()

    fileprivate static var previousColors = [UIColor]()
    fileprivate static var nextColors = [UIColor]()

    @IBOutlet var featureSwitch: UISwitch!

    @IBOutlet var ratioSlider: UISlider! {
        didSet {
            ratioSlider.transform = CGAffineTransform(rotationAngle: .pi / 2)
        }
    }
    @IBOutlet var ratioSliderPointerView: TriangleView! {
        didSet {
            ratioSliderPointerView.direction = .left
        }
    }

    @IBOutlet var gradientLayerView: UIView! {
        didSet {
            gradientLayerView.layer.insertSublayer(gradientLayer, at: 0)
            gradientLayer.frame = gradientLayerView.frame
        }
    }

    fileprivate let gradientLayer: CAGradientLayer = {
        let _gradientLayer = CAGradientLayer()
        _gradientLayer.opacity = 0.25
        _gradientLayer.locations = [0.0 , 1.0]
        _gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        _gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        return _gradientLayer
    }()

    @IBOutlet var mainColorView: UIView!
    @IBOutlet var mainColorHexTextField: UITextField!
    @IBOutlet var secondaryColorView: UIView!
    @IBOutlet var mixedColorView: UIView!
    @IBOutlet var mixedColorLabel: UILabel!
    @IBOutlet var mixedColorMatchLabel: UILabel!
    @IBOutlet var mixedColorNameLabel: UILabel!

    @IBOutlet var secondaryColorCarousel: UICollectionView!
    @IBOutlet var secondaryColorCarouselView: UIView!
    @IBOutlet var secondaryColorCarouselHexLabel: UILabel!
    @IBOutlet var secondaryColorCarouselNameLabel: UILabel!
    @IBOutlet var secondaryColorCarouselSeparator: UIView!
    @IBOutlet var secondaryColorCarouselSelector: TriangleView! {
        didSet {
            secondaryColorCarouselSelector.direction = .up
        }
    }
    @IBOutlet var secondaryColorCarouselSelectorBottom: UIView!

    fileprivate var mixedColor: UIColor = .red

    fileprivate var mainColor: UIColor = .red

    fileprivate var secondaryColor: UIColor {
        return ColorMixViewController.secondaryColors[secondaryColorIndex].color
    }

    fileprivate var secondaryColorIndex: Int = secondaryColors.count / 2 {
        didSet {
            secondaryColorIndex = secondaryColorIndex % ColorMixViewController.secondaryColors.count
        }
    }

    @IBOutlet var previousColorButton: TriangleView! {
        didSet {
            previousColorButton.color = .black
            previousColorButton.direction = .left
        }
    }

    @IBOutlet var nextColorButton: TriangleView! {
        didSet {
            nextColorButton.color = .black
            nextColorButton.direction = .right
        }
    }

    @IBOutlet var mixedColorButtonView: TriangleView! {
        didSet {
            mixedColorButtonView.direction = .up
        }
    }

    @IBOutlet var leftSideBarButton: UIView!
    // TODO: Filters (all, red, orange, ...),
    // Sort (color, hue, brightness, ...)
    // Right Side Bar View: favorited colors
    @IBOutlet var leftSideBarView: UIView!

    @IBOutlet var leftSideBarTriangleView: TriangleView! {
        didSet {
            leftSideBarTriangleView.color = .black
            leftSideBarTriangleView.direction = .right
        }
    }

    fileprivate var tempSecondaryColorIndex: Int?

    fileprivate var originalMainColor: UIColor?
    fileprivate var originalSecondaryColor: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()

        updateMainColor()
        updateSecondaryColor()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let radius: CGFloat = floor(mixedColorView.bounds.width / 2.0)
        mainColorView.round(corners: [.topLeft, .topRight], with: radius)
        secondaryColorView.round(corners: [.bottomLeft, .bottomRight], with: radius)
        mixedColorView.round(with: radius)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gradientLayer.frame = gradientLayerView.frame
        updateMixedColor()

        secondaryColorCarousel.scrollToItem(at: IndexPath(item: secondaryColorIndex, section: 0), at: .centeredHorizontally, animated: false)
    }

    fileprivate func updateMainColor(to newColor: UIColor? = nil, should animate: Bool = false) {
        if let newColor = newColor {
            originalMainColor = mainColor
            mainColor = newColor
        } else {
            originalMainColor = nil
        }
        mainColorHexTextField.text = mainColor.toHexString()
        mainColorView.backgroundColor = mainColor
        updateMixedColor(should: animate)
    }

    fileprivate func tempUpdateSecondaryColor(to index: Int) {
        tempSecondaryColorIndex = index
        let tempSecondaryColor = ColorMixViewController.secondaryColors[index].color
        secondaryColorCarouselView.backgroundColor = tempSecondaryColor
        secondaryColorCarouselHexLabel.text = tempSecondaryColor.toHexString()
        secondaryColorCarouselNameLabel.text = ColorMixViewController.secondaryColors[index].name?.uppercased()

        let contrastColor: UIColor = tempSecondaryColor.brightness() > 0.5 ? .black : .white
        secondaryColorCarouselHexLabel.textColor = contrastColor
        secondaryColorCarouselNameLabel.textColor = contrastColor
        secondaryColorCarouselSeparator.backgroundColor = contrastColor
        secondaryColorCarouselSelector.color = contrastColor
        secondaryColorCarouselSelectorBottom.backgroundColor = contrastColor
    }

    fileprivate func updateSecondaryColor(to index: Int? = nil, should animate: Bool = false) {
        tempSecondaryColorIndex = nil
        if let index = index {
            originalSecondaryColor = secondaryColor
            secondaryColorIndex = index
        } else {
            originalSecondaryColor = nil
        }
        secondaryColorView.backgroundColor = secondaryColor
        secondaryColorCarouselView.backgroundColor = secondaryColor
        secondaryColorCarouselHexLabel.text = secondaryColor.toHexString()
        secondaryColorCarouselNameLabel.text = ColorMixViewController.secondaryColors[secondaryColorIndex].name?.uppercased()

        let contrastColor: UIColor = secondaryColor.brightness() > 0.5 ? .black : .white
        secondaryColorCarouselHexLabel.textColor = contrastColor
        secondaryColorCarouselNameLabel.textColor = contrastColor
        secondaryColorCarouselSeparator.backgroundColor = contrastColor
        secondaryColorCarouselSelector.color = contrastColor
        secondaryColorCarouselSelectorBottom.backgroundColor = contrastColor

        updateMixedColor(should: animate)
    }

    fileprivate func updateMixedColor(should animate: Bool = false) {
        mixedColor = UIColor.mixColor(color1: mainColor, with: secondaryColor, atRatio: CGFloat(ratioSlider.value))
        mixedColorLabel.text = mixedColor.toHexString()

        let allColorsIndex = mixedColor.closestColor(of: ColorLibrary.colors)
        if let closestColorName = ColorLibrary.colors[allColorsIndex].name {
            let similarity: CGFloat = floor((1.0 - ColorLibrary.colors[allColorsIndex].color.similarity(to: mixedColor)) * 100.0)
            if similarity < 100 {
                mixedColorNameLabel.text = "\(closestColorName)"
                mixedColorMatchLabel.text = "\(Int(similarity))% similar"
            } else {
                mixedColorNameLabel.text = "\(closestColorName)"
                mixedColorMatchLabel.text = ""
            }
        }
        if featureSwitch.isOn && animate {
            UIView.animate(withDuration: kColorRotationDuration, animations: {
                self.mixedColorView.backgroundColor = self.mixedColor
            })
        } else {
            mixedColorView.backgroundColor = mixedColor
        }

        ratioSlider.setGradientBackground(with: mainColor, with: secondaryColor)
        ratioSlider.thumbTintColor = mixedColor
        ratioSliderPointerView.color = UIColor.mixColor(color1: mainColor, with: secondaryColor, atRatio: 0.5)

        mainColorView.alpha = min(CGFloat(1 - ratioSlider.value) * 2.0, 1.0)
        secondaryColorView.alpha = min(CGFloat(ratioSlider.value) * 2.0, 1.0)

        mixedColorLabel.textColor = mixedColor.brightness() > 0.5 ? .black : .white
        mixedColorNameLabel.textColor = mixedColorLabel.textColor
        mixedColorMatchLabel.textColor = mixedColorLabel.textColor
        mixedColorButtonView.color = mixedColorLabel.textColor

        leftSideBarView.backgroundColor = UIColor.mixColor(color1: .white, with: mixedColor, atRatio: 0.25)
        leftSideBarButton.backgroundColor = leftSideBarView.backgroundColor

        if featureSwitch.isOn && animate {

            let animateColor = CAAnimation.rotate(topColorView: mainColorView, bottomColorView: secondaryColorView,
                               fromTopColor: originalMainColor, fromBottomColor: originalSecondaryColor,
                               toTopColor: mainColor, toBottomColor: secondaryColor) {
                                self.originalMainColor = nil
                                self.originalSecondaryColor = nil
            }

            assert(animateColor)
        }

        gradientLayer.colors = [mainColor.cgColor, secondaryColor.cgColor]
    }

    fileprivate func updateRatioSlider(to newRatio: CGFloat? = nil) {
        if var newRatio = newRatio {
            let min: CGFloat = 0.05
            let max: CGFloat = 0.95
            if newRatio < min {
                newRatio = min
            } else if newRatio > max {
                newRatio = max
            }
            ratioSlider.setValue(Float(round(newRatio * 20) / 20), animated: false)
        }
        updateMixedColor()
    }

    @IBAction func didChangeRatio(_ sender: UISlider) {
        updateRatioSlider(to: CGFloat(sender.value))
    }

    //refactor
    @IBAction func didTapPreviousButton(_ sender: UITapGestureRecognizer) {

        guard let previousColor = ColorMixViewController.previousColors.last else {
            return
        }

        ColorMixViewController.nextColors.insert(mainColor, at: 0)
        ColorMixViewController.previousColors.removeLast()
        previousColorButton.isHidden = ColorMixViewController.previousColors.count == 0
        nextColorButton.isHidden = ColorMixViewController.nextColors.count == 0

        mainColorHexTextField.text = previousColor.toHexString()
        mainColorHexTextField.textColor = .darkText
        updateMainColor(to: previousColor, should: true)
        mainColorHexTextField.resignFirstResponder()
    }

    @IBAction func didTapNextButton(_ sender: UITapGestureRecognizer) {

        guard let nextColor = ColorMixViewController.nextColors.first else {
            return
        }

        ColorMixViewController.previousColors.append(mainColor)
        ColorMixViewController.nextColors.removeFirst()
        previousColorButton.isHidden = ColorMixViewController.previousColors.count == 0
        nextColorButton.isHidden = ColorMixViewController.nextColors.count == 0

        mainColorHexTextField.text = nextColor.toHexString()
        mainColorHexTextField.textColor = .darkText
        updateMainColor(to: nextColor, should: true)
        mainColorHexTextField.resignFirstResponder()
    }

    @IBAction func didTapMixedColorView(_ sender: Any) {
        if mainColor.toHexString() == mixedColor.toHexString() {
            return
        }
        ColorMixViewController.previousColors.append(mainColor)
        ColorMixViewController.nextColors.removeAll()
        previousColorButton.isHidden = ColorMixViewController.previousColors.count == 0
        nextColorButton.isHidden = ColorMixViewController.nextColors.count == 0

        mainColorHexTextField.text = mixedColor.toHexString()
        mainColorHexTextField.textColor = .darkText
        updateMainColor(to: mixedColor, should: true)
        mainColorHexTextField.resignFirstResponder()
    }
}

extension ColorMixViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = ((textField.text ?? "") as NSString)
        var newString = currentString.replacingCharacters(in: range, with: string)
        if newString.count > 7 {
            newString = String(newString.prefix(7))
        }

        var shouldChange = true

        if newString.rangeOfCharacter(from: CharacterSet.lowercaseLetters) != nil {
            newString = newString.uppercased()
            if newString.isHexString(isComplete: false) {
                textField.text = newString
            }
            shouldChange = false
        } else {
            shouldChange = newString.isHexString(isComplete: false)
        }

        if newString.isHexString() {
            if mainColor.toHexString() != newString {
                ColorMixViewController.previousColors.append(mainColor)
                ColorMixViewController.nextColors.removeAll()
                previousColorButton.isHidden = ColorMixViewController.previousColors.count == 0
                nextColorButton.isHidden = ColorMixViewController.nextColors.count == 0
            }

            textField.textColor = .darkText
            updateMainColor(to: newString.toColor(), should: true)
            textField.resignFirstResponder()
            shouldChange = false
        } else {
            textField.textColor = .red
        }

        return shouldChange
    }
}

extension ColorMixViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ColorMixViewController.secondaryColors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorMix", for: indexPath) as! ColorMixCollectionViewCell
        cell.color = ColorMixViewController.secondaryColors[indexPath.item].color
        cell.active = indexPath.item == secondaryColorIndex
        return cell
    }
}

extension ColorMixViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension ColorMixViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let collectionViewLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        let requiredSpace = (collectionView.bounds.width - collectionViewLayout.itemSize.width) / 2.0
        return UIEdgeInsets(top: 0.0,
                            left: requiredSpace, bottom: 0.0, right: requiredSpace)
    }
}

extension ColorMixViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerPoint = CGPoint(x: secondaryColorCarousel.bounds.midX, y: secondaryColorCarousel.bounds.midY)
        guard let newColorIndexPath = secondaryColorCarousel.indexPathForItem(at: centerPoint) else {
            return
        }
        if secondaryColorIndex == newColorIndexPath.item && (secondaryColorIndex == tempSecondaryColorIndex || tempSecondaryColorIndex == nil) {
            return
        }
        tempUpdateSecondaryColor(to: newColorIndexPath.item)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let centerPoint = CGPoint(x: secondaryColorCarousel.bounds.midX, y: secondaryColorCarousel.bounds.midY)
        guard let newColorIndexPath = secondaryColorCarousel.indexPathForItem(at: centerPoint) else {
            return
        }
        if secondaryColorIndex == newColorIndexPath.item && (secondaryColorIndex == tempSecondaryColorIndex || tempSecondaryColorIndex == nil) {
            secondaryColorCarousel.scrollToItem(at: newColorIndexPath, at: .centeredHorizontally, animated: true)
            return
        }
        secondaryColorCarousel.scrollToItem(at: newColorIndexPath, at: .centeredHorizontally, animated: true)
        updateSecondaryColor(to: newColorIndexPath.item, should: true)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndDecelerating(scrollView)
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(scrollView)
    }
}

class ColorMixCollectionViewCell: UICollectionViewCell {

    @IBOutlet var activeView: TriangleView! {
        didSet {
            activeView.direction = .up
        }
    }

    fileprivate var color: UIColor = .clear {
        didSet {
            backgroundColor = color
            layer.shadowColor = color == .white ? color.cgColor : color.cgColor
        }
    }

    fileprivate var active: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.masksToBounds = false
    }
}
