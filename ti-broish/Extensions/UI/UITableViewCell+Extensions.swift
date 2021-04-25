//
//  UITableViewCell+Extensions.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 25.04.21.
//

import UIKit

extension UITableViewCell {
    
    // MARK: Properties
    
    static var nibName: String {
        return "\(String(describing: self))"
    }
    
    static var cellIdentifier: String {
        return "\(String(describing: self))"
    }
    
}

