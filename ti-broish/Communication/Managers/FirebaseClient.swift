//
//  FirebaseClient.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 26.04.21.
//

import Foundation
import Firebase

class FirebaseClient {
    
    func register() {
        
    }
    
    func login(email: String, password: String, completion: @escaping (Result<String, FirebaseError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in 
            if let _error = error {
                completion(.failure(ErrorHandler.handleFirebaseError(_error)))
            } else {
                if let user = authResult?.user {
                    user.getIDToken { token, error in
                        if let _token = token {
                            completion(.success(_token))
                        } else {
                            completion(.failure(.unknownError))
                        }
                    }
                } else {
                    completion(.failure(.unknownError))
                }
            }
        }
    }
    
    func resetPassword() {
        
    }
    
}
