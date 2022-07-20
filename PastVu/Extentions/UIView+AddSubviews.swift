//
//  UIView+AddSubviews.swift
//  PastVu
//
//  Created by Михаил Апанасенко on 19.07.22.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
    }
}
