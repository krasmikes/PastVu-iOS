//
//  CGFloat+CubicBezier.swift
//  PastVu
//
//  Created by Михаил Апанасенко on 06.08.22.
//

import UIKit

extension CGFloat {
    func cubicBezier(_ p: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 1, 1) ) -> CGFloat? {
        guard 0 <= self && self <= 1 else { return nil }
        let p0 = pow((1-self), 3) * p.0 // (1-t)**3 * P0
        let p1 = 3 * pow((1 - self), 2) * self * p.1 // t*P1*(3*(1-t)**2)
        let p2 = 3 * (1 - self) * pow(self, 2) * p.2 // P2*(3*(1-t)*t**2)
        let p3 = pow(self, 3) * p.3 // P3*t**3
        return p0 + p1 + p2 + p3
    }
}
