//
//  LoginViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 29.04.21.
//

import Foundation

enum LoginFieldType {
    
    case email, password
}

final class LoginViewModel: CoordinatableViewModel {
    
    func makeConfigForLoginInputType(type: LoginFieldType) -> InputFieldConfig {
        switch type {
        case .email:
            return InputFieldConfig(
                type: .email,
                title: LocalizedStrings.Login.emailTitle,
                placeholderText: LocalizedStrings.Login.emailPlaceholder
            )
        case .password:
            return InputFieldConfig(
                type: .password,
                title: LocalizedStrings.Login.passwordTitle,
                placeholderText: LocalizedStrings.Login.passwordPlaceholder
            )
        }
    }
}
