//
//  SendProtocolDataBuilder.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 15.06.21.
//

import Foundation

struct SendProtocolDataBuilder {
    
    func makeConfig(for type: SendFieldType) -> InputFieldConfig? {
        switch type {
        case .section:
            return InputFieldConfig(
                type: .text,
                title: LocalizedStrings.SendInputField.section,
                placeholderText: LocalizedStrings.SendInputField.sectionNumberPlaceholder,
                isRequired: true,
                dataType: SendFieldType.section as AnyObject
            )
        default:
            return nil
        }
    }
}
