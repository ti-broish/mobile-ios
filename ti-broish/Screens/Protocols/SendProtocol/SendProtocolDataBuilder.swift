//
//  SendProtocolDataBuilder.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 15.06.21.
//

import Foundation

enum SendProtocolFieldType: Int, CaseIterable {
    
    case sectionNumber
}

struct SendProtocolDataBuilder {
    
    func makeConfig(for type: SendProtocolFieldType) -> InputFieldConfig {
        switch type {
        case .sectionNumber:
            return InputFieldConfig(
                type: .text,
                title: LocalizedStrings.CommonInputField.firstName,
                placeholderText: LocalizedStrings.CommonInputField.firstNamePlaceholder,
                isRequired: true
            )
        }
    }
}
