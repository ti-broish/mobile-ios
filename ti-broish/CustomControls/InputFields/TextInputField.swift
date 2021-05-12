//
//  TextInputField.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 26.04.21.
//

import UIKit

final class TextInputField: InputField {
    
    override var nibName: String {
        return "TextInputField"
    }
        
    override func setupViews() {
        super.setupViews()
        
        let theme = TibTheme()
        view.backgroundColor = theme.backgroundColor
    }
}
