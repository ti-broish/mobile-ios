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
                title: LocalizedStrings.Registration.firstName,
                placeholderText: LocalizedStrings.Registration.firstNamePlaceholder,
                isRequired: true
            )
        case .lastName:
            return InputFieldConfig(
                type: .text,
                title: LocalizedStrings.Registration.lastName,
                placeholderText: LocalizedStrings.Registration.lastNamePlaceholder,
                isRequired: true
            )
        case .email:
            return InputFieldConfig(
                type: .email,
                title: LocalizedStrings.Registration.email,
                placeholderText: LocalizedStrings.Registration.emailPlaceholder,
                isRequired: true
            )
        case .phone:
            return InputFieldConfig(
                type: .phone,
                title: LocalizedStrings.Registration.phone,
                placeholderText: LocalizedStrings.Registration.phonePlaceholder,
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
                type: .text,
                title: LocalizedStrings.Registration.organization,
                placeholderText: nil,
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
                type: .text,
                title: LocalizedStrings.Registration.hasAgreedToKeepData,
                placeholderText: nil,
                isRequired: false
            )
        case .hasAdulthood:
            return InputFieldConfig(
                type: .text,
                title: LocalizedStrings.Registration.hasAdulthood,
                placeholderText: nil,
                isRequired: true
            )
        }
    }
}
