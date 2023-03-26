//
//  ErrorHandler.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 5.05.21.
//

import Firebase

struct ErrorHandler {
    
    static func handleFirebaseError(_ error: Error) -> FirebaseError {
        let nsError: NSError = error as NSError
        
        switch AuthErrorCode(_nsError: nsError).code {
        case .operationNotAllowed:
            return .operationNotAllowed
        case .invalidEmail:
            return .invalidEmail
        case .userDisabled:
            return .userDisabled
        case .wrongPassword:
            return .wrongPassword
        case .invalidRecipientEmail:
            return .invalidRecipientEmail
        case .userNotFound: 
            return .userNotFound
        case .emailAlreadyInUse:
            return .emailAlreadyInUse
        default:
            return .unknownError
        }
    }
}
