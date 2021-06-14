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
            if let token = token {
                completion(.success(token))
            } else {
                completion(.failure(.unknownError))
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<String, FirebaseError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                completion(.failure(ErrorHandler.handleFirebaseError(error)))
            } else {
                // TODO: - implement emailVerified
                self?.refreshToken(completion: completion)
            }
        }
    }
    
    func resetPassword(email: String, completion: @escaping (Result<Void, FirebaseError>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(ErrorHandler.handleFirebaseError(error)))
            } else {
                completion(.success(()))
            }
        }
    }
}
