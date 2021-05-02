//
//  FirebaseClient.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 26.04.21.
//

import Foundation
import FirebaseAuth

typealias FirebaseUserResult = Result<FirebaseUser, FirebaseError>

class FirebaseClient {
    
    func register() {
        
    }
    
    func login(email: String, password: String, completionHandler: @escaping (FirebaseUserResult) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { result, error in
            if let authError = (error as NSError?) {
                var error: FirebaseError
                switch AuthErrorCode(rawValue: authError.code) {
                case .invalidEmail:
                    error = FirebaseError.invalidEmail
                case .userNotFound:
                    error = FirebaseError.userNotFound
                case .wrongPassword:
                    error = FirebaseError.wrongPassword
                default:
                    error = FirebaseError.other
                }
                completionHandler(.failure(error))
            } else {
                let user = Auth.auth().currentUser
                if let user = user {
                    guard let email = user.email else {
                        completionHandler(.failure(.invalidEmail))
                        return
                    }
                    let firebaseUser = FirebaseUser(uid: user.uid, email: email)
                    completionHandler(.success(firebaseUser))
                }
            }
        })
    }
    
    func resetPassword() {
        
    }
    
}
