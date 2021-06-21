//
//  InputFieldConfig.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 20.05.21.
//

import Foundation

struct InputFieldConfig {

    let type: InputFieldType
    let title: String
    let placeholderText: String?
    let isRequired: Bool
    var data: AnyObject?
    var dataType: AnyObject?
    
    var isTextField: Bool {
        return type != .picker && type != .checkbox
    }
    
    var isPickerField: Bool {
        return type == .picker
    }
    
    var isCheckboxField: Bool {
        return type == .checkbox
    }
    
    init(
        type: InputFieldType,
        title: String,
        placeholderText: String?,
        isRequired: Bool = false,
        data: AnyObject? = nil,
        dataType: AnyObject? = nil
    ) {
        self.type = type
        self.title = title
        self.placeholderText = placeholderText
        self.isRequired = isRequired
        self.data = data
        self.dataType = dataType
    }
}
