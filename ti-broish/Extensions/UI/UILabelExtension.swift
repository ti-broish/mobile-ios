//
//  UILabelExtension.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 19.05.21.
//

import UIKit

extension UILabel {
    
    func setText(_ text: String, isRequired: Bool) {
        if isRequired {
            let redAsterisk = NSAttributedString(
                string: " * ",
                attributes: [.foregroundColor: UIColor.red, .font: UIFont.regularFont(size: 14.0)]
            )
            
            let attrText = NSMutableAttributedString(string: text)
            attrText.append(redAsterisk)
            
            self.attributedText = attrText
        } else {
            self.text = text
        }
    }
}
