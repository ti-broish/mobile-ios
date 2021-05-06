//
//  ErrorHandler.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 5.05.21.
//

import UIKit

struct ErrorHandler {
    
    static func handleFirebaseError(_ error: Error) -> FirebaseError {
        print("handleFirebaseError: \(error)")
        
        return .unknownError
    }
}
