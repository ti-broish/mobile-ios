//
//  FirebaseError.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 5.05.21.
//

import Foundation

enum FirebaseError: Error {
    
    case unknownError
    /// Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console
    case operationNotAllowed
    /// Indicates the email address is malformed
    case invalidEmail
    /// Indicates the user's account is disabled
    case userDisabled
    /// Indicates the user attempted sign in with a wrong password
    case wrongPassword
    
    var localizedString: String {
        switch self {
        case .invalidEmail:
            return LocalizedStrings.Errors.invalidEmail
        case .userDisabled:
            return LocalizedStrings.Errors.userDisabled
        case .wrongPassword:
            return LocalizedStrings.Errors.wrongPassword
        default:
            return LocalizedStrings.Errors.defaultError
        }
    }
}
