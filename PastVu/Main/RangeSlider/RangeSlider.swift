//
//  RangeSlider.swift
//  PastVu
//
//  Created by Михаил Апанасенко on 22.07.22.
//

import UIKit

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

        lowerThumbImageView.image = thumbImage
        lowerThumbImageView.highlightedImage = thumbImageSelected
        addSubview(lowerThumbImageView)
        upperThumbImageView.image = thumbImage
        upperThumbImageView.highlightedImage = thumbImageSelected
        addSubview(upperThumbImageView)
        addSubview(valueLabel)

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
        let cubicBezierParams = SliderConstants.cubicBezier
        return bounds.width * cubicBezier(newValue, cubicBezierParams)
    }

    private func cubicBezier(_ value: CGFloat, _ p: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 1, 1) ) -> CGFloat {
        let p0 = pow((1-value), 3) * p.0 // (1-t)**3 * P0
        let p1 = 3 * pow((1 - value), 2) * value * p.1 // t*P1*(3*(1-t)**2)
        let p2 = 3 * (1 - value) * pow(value, 2) * p.2 // P2*(3*(1-t)*t**2)
        let p3 = pow(value, 3) * p.3 // P3*t**3
        return p0 + p1 + p2 + p3
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
