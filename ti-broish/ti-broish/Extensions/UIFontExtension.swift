//
//  UIFontExtension.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 24.04.21.
//

import UIKit

extension UIFont {
    
    static func montserratFont(name: String, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
            fatalError("Failed to load the \(name) font.")
        }

        return font
    }
    
    static func thisFont(size: CGFloat) -> UIFont {
        return montserratFont(name: "Montserrat-Thin", size: size)
    }
    
    static func extraLightFont(size: CGFloat) -> UIFont {
        return montserratFont(name: "Montserrat-ExtraLight", size: size)
    }
    
    static func lightFont(size: CGFloat) -> UIFont {
        return montserratFont(name: "Montserrat-Light", size: size)
    }
    
    static func regularFont(size: CGFloat) -> UIFont {
        return montserratFont(name: "Montserrat-Regular", size: size)
    }
    
    static func italicFont(size: CGFloat) -> UIFont {
        return montserratFont(name: "Montserrat-Italic", size: size)
    }
    
    static func mediumFont(size: CGFloat) -> UIFont {
        return montserratFont(name: "Montserrat-Medium", size: size)
    }
    
    static func semiBoldFont(size: CGFloat) -> UIFont {
        return montserratFont(name: "Montserrat-SemiBold", size: size)
    }
    
    static func boldFont(size: CGFloat) -> UIFont {
        return montserratFont(name: "Montserrat-Bold", size: size)
    }
    
    static func extraBoldFont(size: CGFloat) -> UIFont {
        return montserratFont(name: "Montserrat-ExtraBold", size: size)
    }
}
