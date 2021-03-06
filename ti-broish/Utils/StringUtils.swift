//
//  StringUtils.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 11.06.21.
//

import UIKit

struct StringUtils {
    
    static func makeAttributedText(prefix: String, text: String, textColor: UIColor) -> NSAttributedString {
        let attrText = NSMutableAttributedString(
            string: "\(prefix): ",
            attributes: [.foregroundColor: TibTheme().darkTextColor, .font: UIFont.regularFont(size: 14.0)]
        )
        
        let attrSection = NSAttributedString(
            string: text,
            attributes: [.foregroundColor: textColor, .font: UIFont.semiBoldFont(size: 14.0)]
        )
        
        attrText.append(attrSection)
        
        return attrText
    }
    
    static func stringToColor(hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return TibTheme().darkTextColor
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
