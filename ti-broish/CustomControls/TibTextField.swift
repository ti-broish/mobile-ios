//
//  TibTextField.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 29.04.21.
//

import UIKit

final class TibTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 8.0, dy: 8.0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 8.0, dy: 8.0)
    }
}
