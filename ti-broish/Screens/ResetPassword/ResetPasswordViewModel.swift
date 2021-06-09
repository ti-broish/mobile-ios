//
//  ResetPasswordViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 9.06.21.
//

import Foundation

enum ResetFieldType {
    
    case email
}

final class ResetPasswordViewModel {
    
    func makeConfig(for type: ResetFieldType) -> InputFieldConfig {
        switch type {
        case .email:
            return InputFieldConfig(
                type: .email,
                title: LocalizedStrings.ResetPassword.email,
                placeholderText: LocalizedStrings.ResetPassword.emailPlaceholder
            )
        }
    }
}
