//
//  RangeSliderTrackLayer.swift
//  PastVu
//
//  Created by Михаил Апанасенко on 25.07.22.
//

import UIKit

class RangeSliderTrackLayer: CAGradientLayer {
    weak var rangeSlider: RangeSlider?

    override func draw(in ctx: CGContext) {
        guard let slider = rangeSlider else {
            return
        }

        type = .axial
        let activeColors = [
            CGColor(red: 0, green: 0, blue: 102, alpha: 1),
            CGColor(red: 0, green: 0, blue: 171, alpha: 1),
            CGColor(red: 57, green: 0, blue: 171, alpha: 1),
            CGColor(red: 114, green: 0, blue: 171, alpha: 1),
            CGColor(red: 171, green: 0, blue: 171, alpha: 1),
            CGColor(red: 171, green: 0, blue: 114, alpha: 1),
            CGColor(red: 171, green: 0, blue: 57, alpha: 1),
            CGColor(red: 171, green: 0, blue: 0, alpha: 1),
            CGColor(red: 171, green: 57, blue: 0, alpha: 1),
            CGColor(red: 171, green: 114, blue: 0, alpha: 1),
            CGColor(red: 171, green: 171, blue: 0, alpha: 1),
            CGColor(red: 114, green: 171, blue: 0, alpha: 1),
            CGColor(red: 57, green: 171, blue: 0, alpha: 1),
            CGColor(red: 0, green: 171, blue: 0, alpha: 1),
        ]
        let inactiveColors = activeColors.map { $0.copy(alpha: 0.3) }

        let lowerValuePosition = slider.positionForValue(slider.lowerValue.cgFloat)
        let upperValuePosition = slider.positionForValue(slider.upperValue.cgFloat)

        let activeRect = CGRect(
            x: lowerValuePosition,
            y: 0,
            width: upperValuePosition - lowerValuePosition,
            height: bounds.height
        )

        let inactivePath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        let activePath = UIBezierPath(roundedRect: activeRect, cornerRadius: cornerRadius)
        let colorspace = CGColorSpaceCreateDeviceRGB()
        let locations : [CGFloat] = [
            0,
            0.3,
            0.36,
            0.42,
            0.48,
            0.53,
            0.59,
            0.65,
            0.71,
            0.76,
            0.82,
            0.88,
            0.94,
            1.0
        ]
        let cubicBezierLocations: [CGFloat] = locations.map { $0.cubicBezier(SliderConstants.cubicBezier) ?? 0 }
        let inactiveGradient = CGGradient(colorsSpace: colorspace, colors: inactiveColors as CFArray, locations: cubicBezierLocations)!
        let activeGradient = CGGradient(colorsSpace: colorspace, colors: activeColors as CFArray, locations: cubicBezierLocations)!

        ctx.saveGState()
        ctx.addPath(inactivePath.cgPath)
        ctx.clip()
        ctx.drawLinearGradient(
            inactiveGradient,
            start: .zero,
            end: CGPoint(x: frame.width, y: 0),
            options: []
        )
        ctx.addPath(activePath.cgPath)
        ctx.clip()
        ctx.drawLinearGradient(activeGradient, start: .zero, end: CGPoint(x: frame.width, y: 0), options: [])
        ctx.restoreGState()
    }
}
