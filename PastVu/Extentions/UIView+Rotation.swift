//
//  UIView+Rotation.swift
//  PastVu
//
//  Created by Михаил Апанасенко on 02.06.22.
//

import UIKit

// MARK: - UIView Extension
extension UIView {

    /**
     Rotate a view by specified degrees
     parameter angle: angle in degrees

     Source: https://stackoverflow.com/a/35656911
     */

    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians);
        self.transform = rotation
    }

}
