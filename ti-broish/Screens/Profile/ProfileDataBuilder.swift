//
//  ProfileDataBuilder.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 13.06.21.
//

import Foundation

enum ProfileFieldType: Int, CaseIterable {
    
    case firstName
    case lastName
    case email
    case phone
    case organization
    case hasAgreedToKeepData
}

struct ProfileDataBuilder {
    
    func makeConfig(for type: ProfileFieldType) -> InputFieldConfig {
        switch type {
        case .firstName:
            return InputFieldConfig(
                type: .text,
                title: LocalizedStrings.CommonInputField.firstName,
                placeholderText: LocalizedStrings.CommonInputField.firstNamePlaceholder,
                isRequired: true
            )
        case .lastName:
            return InputFieldConfig(
                type: .text,
                title: LocalizedStrings.CommonInputField.lastName,
                placeholderText: LocalizedStrings.CommonInputField.lastNamePlaceholder,
                isRequired: true
            )
        case .email:
            return InputFieldConfig(
                type: .email,
                title: LocalizedStrings.CommonInputField.email,
                placeholderText: LocalizedStrings.CommonInputField.emailPlaceholder,
                isRequired: false
            )
        case .phone:
            return InputFieldConfig(
                type: .phone,
                title: LocalizedStrings.CommonInputField.phone,
                placeholderText: LocalizedStrings.CommonInputField.phonePlaceholder,
                isRequired: true
            )
        case .organization:
            return InputFieldConfig(
                type: .picker,
                title: LocalizedStrings.CommonInputField.organization,
                placeholderText: LocalizedStrings.CommonInputField.organizationPlaceholder,
                isRequired: true
            )
        case .hasAgreedToKeepData:
            return InputFieldConfig(
                type: .checkbox,
                title: LocalizedStrings.CommonInputField.hasAgreedToKeepData,
                placeholderText: nil,
                isRequired: false
            )
        }
    }
}
