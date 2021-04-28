//
//  TibTheme.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 23.04.21.
//

import UIKit

class TibTheme {
    
    static let shared = TibTheme()
    
    var backgroundColor: UIColor {
        return .backgroundColor
    }
    
    var navigationBarTintColor: UIColor {
        return .primaryColor
    }
    
    var navigationBarTextColor: UIColor {
        return .white
    }
    
    var tableViewSeparatorColor: UIColor {
        return .primaryColor
    }
    
    var titleLabelTextColor: UIColor {
        return .black
    }
    
    var textFieldColor: UIColor {
        return .black
    }
    
    var textFieldPlaceholderColor: UIColor {
        return .placeholderTextColor
    }
    
    var buttonBackgroundColor: UIColor {
        return .clear
    }
    
    var buttonTextColor: UIColor {
        return .primaryColor
    }
    
    var solidButtonBackgroundColor: UIColor {
        return .primaryColor
    }
    
    var solidButtonTextColor: UIColor {
        return .white
    }
}
