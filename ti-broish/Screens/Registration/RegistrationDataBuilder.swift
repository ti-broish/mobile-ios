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
    
    func makeInputFieldForRegistrationField(type: RegistrationFieldType) -> InputFieldModel {
        switch type {
        case .firstName:
            return InputFieldModel(
                type: .text,
                value: nil,
                title: LocalizedStrings.Registration.firstName,
                placeholderText: LocalizedStrings.Registration.firstNamePlaceholder,
                isRequired: true
            )
        case .lastName:
            return InputFieldModel(
                type: .text,
                value: nil,
                title: LocalizedStrings.Registration.lastName,
                placeholderText: LocalizedStrings.Registration.lastNamePlaceholder,
                isRequired: true
            )
        case .email:
            return InputFieldModel(
                type: .email,
                value: nil,
                title: LocalizedStrings.Registration.email,
                placeholderText: LocalizedStrings.Registration.emailPlaceholder,
                isRequired: true
            )
        case .phone:
            return InputFieldModel(
                type: .phone,
                value: nil,
                title: LocalizedStrings.Registration.phone,
                placeholderText: LocalizedStrings.Registration.phonePlaceholder,
                isRequired: true
            )
        case .pin:
            return InputFieldModel(
                type: .pin,
                value: nil,
                title: LocalizedStrings.Registration.pin,
                placeholderText: LocalizedStrings.Registration.pinPlaceholder,
                isRequired: true
            )
        case .organization:
            return InputFieldModel(
                type: .text,
                value: nil,
                title: LocalizedStrings.Registration.organization,
                placeholderText: nil,
                isRequired: true
            )
        case .password:
            return InputFieldModel(
                type: .password,
                value: nil,
                title: LocalizedStrings.Registration.password,
                placeholderText: LocalizedStrings.Registration.passwordPlaceholder,
                isRequired: true
            )
        case .confirmPassword:
            return InputFieldModel(
                type: .password,
                value: nil,
                title: LocalizedStrings.Registration.confirmPassword,
                placeholderText: LocalizedStrings.Registration.confirmPasswordPlaceholder,
                isRequired: true
            )
        case .hasAgreedToKeepData:
            return InputFieldModel(
                type: .text,
                value: nil,
                title: LocalizedStrings.Registration.hasAgreedToKeepData,
                placeholderText: nil,
                isRequired: false
            )
        case .hasAdulthood:
            return InputFieldModel(
                type: .text,
                value: nil,
                title: LocalizedStrings.Registration.hasAdulthood,
                placeholderText: nil,
                isRequired: true
            )
        }
    }
}
