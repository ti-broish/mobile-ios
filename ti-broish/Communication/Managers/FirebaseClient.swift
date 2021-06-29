//
//  FirebaseClient.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 26.04.21.
//

import Foundation
import Firebase

class FirebaseClient {
    
    func register(email: String, password: String, completion: @escaping (Result<String, FirebaseError>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(ErrorHandler.handleFirebaseError(error)))
            } else {
                authResult?.user.getIDToken(completion: { token, error in
                    if let error = error {
                        completion(.failure(ErrorHandler.handleFirebaseError(error)))
                    } else {
                        if let token = token, let uid = authResult?.user.uid {
                            LocalStorage.User().setJwt(token)
                            completion(.success(uid))
                        } else {
                            completion(.failure(.unknownError))
                        }
                    }
                })
            }
        }
    }
    
    func refreshToken(completion: @escaping (Result<String, FirebaseError>) -> Void) {
        Auth.auth().currentUser?.getIDToken { token, error in
            if let token = token {
                completion(.success(token))
            } else {
                if let error = error {
                    completion(.failure(ErrorHandler.handleFirebaseError(error)))
                } else {
                    completion(.failure(.unknownError))
                }
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<String, FirebaseError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                completion(.failure(ErrorHandler.handleFirebaseError(error)))
            } else {
                if authResult?.user.isEmailVerified ?? false {
                    self?.refreshToken(completion: completion)
                } else {
                    self?.sendEmailVerification { result in
                        switch result {
                        case .success:
                            completion(.failure(.emailNotVerified))
                        case .failure(let error):
                            completion(.failure(ErrorHandler.handleFirebaseError(error)))
                        }
                    }
                }
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
    
    func sendEmailVerification(completion: @escaping (Result<Void, FirebaseError>) -> Void) {
        Auth.auth().currentUser?.sendEmailVerification { error in
            if let error = error {
                completion(.failure(ErrorHandler.handleFirebaseError(error)))
            } else {
                completion(.success(()))
            }
        }
    }
}
