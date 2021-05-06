//
//  FirebaseClient.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 26.04.21.
//

import Foundation
import Firebase

//typealias FirebaseResult = (Swift.Result<String, FirebaseError>) -> Void

class FirebaseClient {
    
    func register() {
        
    }
    
    func login(email: String, password: String, completion: @escaping (Result<User, FirebaseError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let _error = error {
                completion(.failure(ErrorHandler.handleFirebaseError(_error)))
            } else {
                if let user = authResult?.user {
                    completion(.success(user))
                } else {
                    completion(.failure(.unknownError))
                }
            }
        }
    }
    
    func resetPassword() {
        
    }
    
}
