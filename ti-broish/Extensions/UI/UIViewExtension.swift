//
//  UIViewExtension.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 13.06.21.
//

import UIKit

extension UIView {

    func setBorder(radius: CGFloat = 4.0, width: CGFloat = 1.0, color: UIColor) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}
