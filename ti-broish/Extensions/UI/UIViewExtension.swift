//
//  UIViewExtension.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 13.06.21.
//

import UIKit
import Toast

extension UIView {

    func setBorder(radius: CGFloat = 4.0, width: CGFloat = 1.0, color: UIColor) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func removeBorder() {
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0.0
    }
    
    // MARK: - Toast
    
    func showLoading() {
        self.makeToastActivity(.center)
    }
    
    func hideLoading() {
        self.hideToastActivity()
    }
    
    func showMessage(_ message: String, position: ToastPosition = .bottom) {
        self.makeToast(message, duration: 3.0, position: position)
    }
}
