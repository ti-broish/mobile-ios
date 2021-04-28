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
    
    func makeLoginFieldForLoginInputType(type: LoginFieldType) -> InputFieldModel {
        switch type {
        case .email:
            return InputFieldModel(
                type: .email,
                title: LocalizedStrings.Login.emailTitle,
                placeholderText: LocalizedStrings.Login.emailPlaceholder
            )
        case .password:
            return InputFieldModel(
                type: .password,
                title: LocalizedStrings.Login.passwordTitle,
                placeholderText: LocalizedStrings.Login.passwordPlaceholder
            )
        }
    }
}
