//
//  InputFieldData.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 11.05.21.
//

import Foundation

struct InputFieldData {

    let type: InputFieldType
    let title: String
    let placeholderText: String?
    let isRequired: Bool
    var data: AnyObject?
    
    var isTextInputField: Bool {
        return type != .picker && type != .checkbox
    }
    
    var isPickerInputField: Bool {
        return type == .picker
    }
    
    var isCheckboxInputField: Bool {
        return type == .checkbox
    }
    
    init(
        type: InputFieldType,
        title: String,
        placeholderText: String?,
        isRequired: Bool = false,
        data: AnyObject? = nil
    ) {
        self.type = type
        self.title = title
        self.placeholderText = placeholderText
        self.isRequired = isRequired
        self.data = data
    }
}

