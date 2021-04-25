//
//  TibViewControllable.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 23.04.21.
//

import UIKit

protocol TibViewControllable {
    
    static var nibName: String { get }
    
    func applyTheme()
}

extension TibViewControllable {
    
    static var nibName: String {
        return "\(String(describing: self))"
    }
}
