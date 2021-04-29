//
//  InputFieldConfig.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 29.04.21.
//

import Foundation

struct InputFieldConfig {

    let type: InputFieldType
    let title: String
    let placeholderText: String?
    let isRequired: Bool
    
    var isTextInputField: Bool {
        return type != .picker || type != .checkbox
    }
    
    init(type: InputFieldType, title: String, placeholderText: String?, isRequired: Bool = false) {
        self.type = type
        self.title = title
        self.placeholderText = placeholderText
        self.isRequired = isRequired
    }
}
