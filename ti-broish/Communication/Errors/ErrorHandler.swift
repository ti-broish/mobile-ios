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
        print("handleFirebaseError: \(nsError)")
        
        guard let errorCode: AuthErrorCode = AuthErrorCode(rawValue: nsError.code) else {
            return .unknownError
        }
        
        switch errorCode {
        case .operationNotAllowed:
            return .operationNotAllowed
        case .invalidEmail:
            return .invalidEmail
        case .userDisabled:
            return .userDisabled
        case .wrongPassword:
            return .wrongPassword
        default:
            return .unknownError
        }
    }
}
