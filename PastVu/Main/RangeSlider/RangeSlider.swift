//
//  RangeSlider.swift
//  PastVu
//
//  Created by Михаил Апанасенко on 22.07.22.
//

import UIKit
import EasyAnchor

class RangeSlider: UIControl {
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    private var minimumValue: Int
    private var maximumValue: Int
    var lowerValue: Int
    var upperValue: Int

    private let thumbSize = SliderConstants.thumbSize

    private var previousLocation = CGPoint()

    private let trackLayer = RangeSliderTrackLayer()
    private let lowerThumbImageView = UIImageView()
    private let upperThumbImageView = UIImageView()
    private let valueLabel = UILabel()
    private let lowerValueLabel = UILabel()
    private let upperValueLabel = UILabel()

    private let thumbImage = UIImage(named: "sliderThumb")
    private let thumbImageSelected = UIImage(named: "sliderThumbSelected")

    init(minimumYear: Int, maximumYear: Int, lowerYear: Int, upperYear: Int) {
        minimumValue = minimumYear
        maximumValue = maximumYear
        lowerValue = lowerYear
        upperValue = upperYear
        super.init(frame: .zero)

        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)

        valueLabel.frame.size = CGSize(width: 40, height: 20)
        valueLabel.clipsToBounds = true
        valueLabel.layer.cornerRadius = valueLabel.frame.height / 2
        valueLabel.backgroundColor = .black.withAlphaComponent(0.5)
        valueLabel.font = .systemFont(ofSize: 12)
        valueLabel.textColor = .white
        valueLabel.textAlignment = .center
        valueLabel.isHidden = true
        
        lowerValueLabel.layer.cornerRadius = 5
        lowerValueLabel.layer.masksToBounds = true
        lowerValueLabel.backgroundColor = .black.withAlphaComponent(0.5)
        lowerValueLabel.font = .systemFont(ofSize: 18, weight: .medium)
        lowerValueLabel.textColor = .white
        lowerValueLabel.textAlignment = .center
        
        upperValueLabel.layer.cornerRadius = 5
        upperValueLabel.layer.masksToBounds = true
        upperValueLabel.backgroundColor = .black.withAlphaComponent(0.5)
        upperValueLabel.font = .systemFont(ofSize: 18, weight: .medium)
        upperValueLabel.textColor = .white
        upperValueLabel.textAlignment = .center
        

        lowerThumbImageView.image = thumbImage
        lowerThumbImageView.highlightedImage = thumbImageSelected
        addSubview(lowerThumbImageView)
        upperThumbImageView.image = thumbImage
        upperThumbImageView.highlightedImage = thumbImageSelected
        addSubview(upperThumbImageView)
        addSubview(valueLabel)
        addSubview(lowerValueLabel)
        addSubviews(upperValueLabel)
        activate(
            lowerValueLabel.anchor.width.equal.to(50),
            lowerValueLabel.anchor.height.equal.to(25),
            lowerValueLabel.anchor.leading,
            lowerValueLabel.anchor.bottom.equal.to(anchor.top).constant(-5),
            
            upperValueLabel.anchor.width.equal.to(50),
            upperValueLabel.anchor.height.equal.to(25),
            upperValueLabel.anchor.trailing,
            upperValueLabel.anchor.bottom.equal.to(anchor.top).constant(-5)
        )
        lowerValueLabel.text = String(lowerYear)
        upperValueLabel.text = String(upperYear)
        updateLayerFrames()
    }

    func updateSizes() {
        updateLayerFrames()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateLayerFrames() {
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
        trackLayer.setNeedsDisplay()
        lowerThumbImageView.frame = CGRect(
            origin: thumbOriginForValue(lowerValue.cgFloat),
            size: thumbSize
        )
        upperThumbImageView.frame = CGRect(
            origin: thumbOriginForValue(upperValue.cgFloat),
            size: thumbSize
        )
    }

    func positionForValue(_ value: CGFloat) -> CGFloat {
        let range = maximumValue - minimumValue
        let newValue = (value - minimumValue.cgFloat) / range.cgFloat
        return bounds.width * (newValue.cubicBezier(SliderConstants.cubicBezier) ?? 0)
    }

    private func thumbOriginForValue(_ value: CGFloat) -> CGPoint {
        let x = positionForValue(value) - thumbSize.width / 2
        let y = (bounds.height - thumbSize.height) / 2
        return CGPoint(x: x, y: y)
    }

    private func updateValueLabelFrameAndShow(_ selectedThumb: UIImageView) {
        valueLabel.text = lowerThumbImageView.isHighlighted ? String(lowerValue) : String(upperValue)
        let minX = selectedThumb.frame.midX - valueLabel.frame.width / 2
        let maxX = selectedThumb.frame.midX + valueLabel.frame.width / 2
        let y = selectedThumb.frame.minY - valueLabel.frame.height - 10

        if minX >= bounds.minX && maxX <= bounds.maxX  {
            valueLabel.frame.origin = CGPoint(
                x: minX,
                y: y
            )
        } else {
            valueLabel.frame.origin = CGPoint(
                x: minX < bounds.minX ? bounds.minX : bounds.maxX - valueLabel.frame.width,
                y: y
            )
        }
        valueLabel.isHidden = false
        
        lowerValueLabel.text = String(lowerValue)
        upperValueLabel.text = String(upperValue)
    }
}

extension RangeSlider {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)

        if lowerThumbImageView.frame.contains(previousLocation) {
            lowerThumbImageView.isHighlighted = true
            updateValueLabelFrameAndShow(lowerThumbImageView)
        } else if upperThumbImageView.frame.contains(previousLocation) {
            upperThumbImageView.isHighlighted = true
            updateValueLabelFrameAndShow(upperThumbImageView)
        }

        return lowerThumbImageView.isHighlighted || upperThumbImageView.isHighlighted
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let deltaLocation = location.x - previousLocation.x
        let deltaValue = Int(CGFloat(maximumValue - minimumValue) * deltaLocation / bounds.width)
        if deltaValue != 0 {
            previousLocation = location
            if lowerThumbImageView.isHighlighted {
                lowerValue += deltaValue
                lowerValue = boundValue(
                    lowerValue, toLowerValue: minimumValue,
                    upperValue: upperValue
                )
            } else if upperThumbImageView.isHighlighted {
                upperValue += deltaValue
                upperValue = boundValue(
                    upperValue, toLowerValue: lowerValue,
                    upperValue: maximumValue
                )
            }
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            updateLayerFrames()
            updateValueLabelFrameAndShow(lowerThumbImageView.isHighlighted ? lowerThumbImageView : upperThumbImageView)
            CATransaction.commit()
        }
        return true
    }

    private func boundValue(_ value: Int, toLowerValue lowerValue: Int, upperValue: Int) -> Int {
        return min(max(value, lowerValue), upperValue)
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        sendActions(for: .valueChanged)
        valueLabel.isHidden = true
        lowerThumbImageView.isHighlighted = false
        upperThumbImageView.isHighlighted = false
    }
}
