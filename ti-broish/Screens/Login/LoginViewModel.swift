//
//  LoginViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 29.04.21.
//

import Foundation

enum LoginFieldType {
    
    case email, password
}

final class LoginViewModel: CoordinatableViewModel {
    
    private let firebaseClient = FirebaseClient()
    
    func makeConfig(for type: LoginFieldType) -> InputFieldConfig {
        switch type {
        case .email:
            return InputFieldConfig(
                type: .email,
                title: LocalizedStrings.Login.emailTitle,
                placeholderText: LocalizedStrings.Login.emailPlaceholder
            )
        case .password:
            return InputFieldConfig(
                type: .password,
                title: LocalizedStrings.Login.passwordTitle,
                placeholderText: LocalizedStrings.Login.passwordPlaceholder
            )
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<Bool, FirebaseError>) -> (Void)) {
        firebaseClient.login(email: email, password: password) { result in
            switch result {
            case .success(let jwt):
                print("firebase jwt: \(jwt)")
                LocalStorage.Login().save(email: email)
                LocalStorage.User().setJwt(jwt)
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
