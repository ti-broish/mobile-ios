//
//  FirebaseError.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 5.05.21.
//

import Foundation

enum FirebaseAppCheckError: Error {
    case checkError((any Error)?)
    case invalidToken
}

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
    /// Indicates an invalid recipient email was sent in the request
    case invalidRecipientEmail
    /// Indicates the user account was not found
    case userNotFound
    /// The email address is already in use by another account
    case emailAlreadyInUse
    ///
    case emailNotVerified
    
    var localizedString: String {
        switch self {
        case .invalidEmail:
            return LocalizedStrings.Errors.invalidEmail
        case .userDisabled:
            return LocalizedStrings.Errors.userDisabled
        case .wrongPassword:
            return LocalizedStrings.Errors.wrongPassword
        case .invalidRecipientEmail:
            return LocalizedStrings.Errors.userNotFound
        case .userNotFound:
            return LocalizedStrings.Errors.userNotFound
        case .emailAlreadyInUse:
            return LocalizedStrings.Errors.emailAlreadyInUse
        case .emailNotVerified:
            return LocalizedStrings.Errors.emailNotVerified
        default:
            return LocalizedStrings.Errors.defaultError
        }
    }
}
