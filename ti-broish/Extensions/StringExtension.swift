//
//  StringExtension.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 6.07.21.
//

import UIKit

extension String {
    
    func makeLiveText() -> NSAttributedString {
        let attrText = NSMutableAttributedString(string: self)
        let range = NSRange(location: self.count - 4, length: 4) // live text
        attrText.addAttribute(.foregroundColor, value: UIColor.white, range: range)
        attrText.addAttribute(.backgroundColor, value: UIColor.red, range: range)
        attrText.addAttribute(.font, value: UIFont.semiBoldFont(size: 16.0), range: range)
        
        return attrText
    }
}
