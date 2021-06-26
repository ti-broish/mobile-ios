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
        case .sectionNumber:
            return InputFieldConfig(
                type: .text,
                title: LocalizedStrings.SendInputField.section,
                placeholderText: LocalizedStrings.SendInputField.sectionNumberPlaceholder,
                isRequired: true
            )
        default:
            return nil
        }
    }
}
