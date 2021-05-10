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
    
    func refreshToken(completion: @escaping (Result<String, FirebaseError>) -> Void) {
        Auth.auth().currentUser?.getIDToken { token, error in
            if let _token = token {
                completion(.success(_token))
            } else {
                completion(.failure(.unknownError))
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<String, FirebaseError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let _error = error {
                completion(.failure(ErrorHandler.handleFirebaseError(_error)))
            } else {
                self?.refreshToken(completion: completion)
            }
        }
    }
    
    func resetPassword() {
        
    }
}
