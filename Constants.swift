//
//  Constants.swift
//  PastVu
//
//  Created by Михаил Апанасенко on 02.08.22.
//

import UIKit

struct SliderConstants {
    static let thumbSize = CGSize(width: 30, height: 30)
    static let rangeBoundaries = (minimumYear: 1826, maximumYear: 2000)

    ///For more information at this page: https://blog.maximeheckel.com/posts/cubic-bezier-from-math-to-motion/
    static let cubicBezier = (
        CGFloat(0),
        CGFloat(0.20),
        CGFloat(0.66),
        CGFloat(1)
    )
}
