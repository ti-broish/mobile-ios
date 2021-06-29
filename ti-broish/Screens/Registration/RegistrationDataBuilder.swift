//
//  RegistrationDataBuilder.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 29.04.21.
//

import Foundation

enum RegistrationFieldType: Int, CaseIterable {
    
    case firstName
    case lastName
    case email
    case phone
    case pin
    case organization
    case password
    case confirmPassword
    case hasAgreedToKeepData
    case hasAdulthood
}

struct RegistrationDataBuilder {

    func makeConfig(for type: RegistrationFieldType) -> InputFieldConfig {
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
                isRequired: true
            )
        case .phone:
            return InputFieldConfig(
                type: .phone,
                title: LocalizedStrings.CommonInputField.phone,
                placeholderText: LocalizedStrings.CommonInputField.phonePlaceholder,
                isRequired: true
            )
        case .pin:
            return InputFieldConfig(
                type: .pin,
                title: LocalizedStrings.Registration.pin,
                placeholderText: LocalizedStrings.Registration.pinPlaceholder,
                isRequired: true
            )
        case .organization:
            return InputFieldConfig(
                type: .picker,
                title: LocalizedStrings.CommonInputField.organization,
                placeholderText: LocalizedStrings.CommonInputField.organizationPlaceholder,
                isRequired: true
            )
        case .password:
            return InputFieldConfig(
                type: .password,
                title: LocalizedStrings.Registration.password,
                placeholderText: LocalizedStrings.Registration.passwordPlaceholder,
                isRequired: true
            )
        case .confirmPassword:
            return InputFieldConfig(
                type: .password,
                title: LocalizedStrings.Registration.confirmPassword,
                placeholderText: LocalizedStrings.Registration.confirmPasswordPlaceholder,
                isRequired: true
            )
        case .hasAgreedToKeepData:
            return InputFieldConfig(
                type: .checkbox,
                title: LocalizedStrings.CommonInputField.hasAgreedToKeepData,
                placeholderText: nil,
                isRequired: false
            )
        case .hasAdulthood:
            return InputFieldConfig(
                type: .checkbox,
                title: LocalizedStrings.Registration.hasAdulthood,
                placeholderText: nil,
                isRequired: true
            )
        }
    }
}
