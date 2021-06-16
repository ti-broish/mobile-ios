//
//  ResetPasswordDataBuilder.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 16.06.21.
//

import Foundation

enum ResetPasswordFieldType: Int, CaseIterable {
    
    case email
}

struct ResetPasswordDataBuilder {
    
    func makeConfig(for type: ResetPasswordFieldType) -> InputFieldConfig {
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
