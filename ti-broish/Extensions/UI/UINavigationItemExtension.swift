//
//  UINavigationItemExtension.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 10.06.21.
//

import UIKit

extension UINavigationItem {
    
    func configureBackButton() {
        self.backBarButtonItem = UIBarButtonItem(title: LocalizedStrings.back, style: .plain, target: nil, action: nil)
    }
}
