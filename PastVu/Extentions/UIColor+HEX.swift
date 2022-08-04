//
//  UIColor+HEX.swift
//  PastVu
//
//  Created by Михаил Апанасенко on 04.08.22.
//

import UIKit

extension UIColor {
    var hexString: String? {
        guard let components = self.cgColor.components else { return nil }

        let hexFormat = "#%02lX%02lX%02lX%02lX"
        var hexString: String?
        if components.count == 2 {
            let all: CGFloat = components[0]
            let alpha: CGFloat = components[1]
            hexString = String(
                format: hexFormat,
                (Int)(all * 255),
                (Int)(all * 255),
                (Int)(all * 255),
                (Int)(alpha * 255)
            )
        } else {
            let r: CGFloat = components[0]
            let g: CGFloat = components[1]
            let b: CGFloat = components[2]
            let alpha: CGFloat = components[3]
            hexString = String(
                format: hexFormat,
                (Int)(r * 255),
                (Int)(g * 255),
                (Int)(b * 255),
                (Int)(alpha * 255)
            )
        }
        return hexString
    }
}
