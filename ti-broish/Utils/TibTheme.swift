//
//  TibTheme.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 23.04.21.
//

import UIKit

class TibTheme {
    
    static func changeAppearance() {
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = LocalizedStrings.Buttons.cancel
    }
    
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
    
    var textColor: UIColor {
        return .black
    }
    
    var darkTextColor: UIColor {
        return .darkTextColor
    }
    
    var placeholderColor: UIColor {
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
    
    var defaultButtonHeight: CGFloat {
        return 44.0
    }
}
