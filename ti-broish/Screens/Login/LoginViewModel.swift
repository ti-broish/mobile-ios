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

final class LoginViewModel: BaseViewModel, CoordinatableViewModel {
    
    var coordinator: LoginCoordinator?
    
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
        loadingPublisher.send(true)
        APIManager.shared.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let jwt):
                LocalStorage.Login().save(email: email)
                LocalStorage.User().setJwt(jwt)
                self?.loadingPublisher.send(false)
                completion(.success(true))
            case .failure(let error):
                self?.loadingPublisher.send(false)
                completion(.failure(error))
            }
        }
    }
}
