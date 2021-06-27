//
//  UIButtonExtension.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 25.04.21.
//

import UIKit

extension UIButton {
    
    func configureButton(title: String, theme: TibTheme, fontSize: CGFloat = 16.0) {
        backgroundColor = theme.buttonBackgroundColor
        setTitleColor(theme.buttonTextColor, for: .normal)
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.regularFont(size: fontSize)
    }
    
    func configureSolidButton(title: String, theme: TibTheme, fontSize: CGFloat = 16.0) {
        layer.cornerRadius = 8.0
        backgroundColor = theme.solidButtonBackgroundColor
        setTitleColor(theme.solidButtonTextColor, for: .normal)
        setTitleColor(theme.solidButtonTextColor.withAlphaComponent(0.5), for: .highlighted)
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.regularFont(size: fontSize)
    }
}
