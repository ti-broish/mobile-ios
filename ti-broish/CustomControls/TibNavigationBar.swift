//
//  TibNavigationBar.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 23.04.21.
//

import UIKit

final class TibNavigationBar: UINavigationBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isTranslucent = false
        
        let theme = TibTheme()
        barTintColor = theme.navigationBarTintColor
        tintColor = theme.navigationBarTextColor
        titleTextAttributes = [.foregroundColor: theme.navigationBarTextColor]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
