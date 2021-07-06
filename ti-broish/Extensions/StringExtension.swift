//
//  StringExtension.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 6.07.21.
//

import UIKit

extension String {
    
    func makeLiveText(textColor: UIColor) -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: UIFont.regularFont(size: 16.0)
        ]
        
        let attrText = NSMutableAttributedString(string: self, attributes: attributes)
        // live
        let range = NSRange(location: self.count - 4, length: 4) // live text
        attrText.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        attrText.addAttribute(.font, value: UIFont.semiBoldFont(size: 16.0), range: range)
        
        return attrText
    }
}
