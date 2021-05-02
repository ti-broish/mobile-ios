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
    private var firebaseClient = FirebaseClient()

    let firebaseError: Observer<String?> = Observer(nil)
    let firebaseUser: Observer<FirebaseUser?> = Observer(nil)

    func fetchFirebaseUser(email: String, password: String) {
        self.firebaseClient.login(email: email, password: password, completionHandler: { [weak self] result in
            switch result {
                case .success(let user):
                    // TODO: get user data from ti-broish API
                    self?.firebaseUser.value = user
                case .failure(let error):
                    let errorMessage: String
                    switch error {
                        case .invalidEmail:
                            errorMessage = "Моля въведете валиден имейл адрес."
                        case .userNotFound:
                            errorMessage = "Потребител с този имейл не съществува."
                        case .wrongPassword:
                            errorMessage = "Грешна парола. Моля опитайте отново."
                        default:
                            errorMessage = "Възникна грешка. Моля опитайте по-късно."
                    }
                    self?.firebaseError.value = errorMessage
            }
        })
    }
    
    func makeConfigForLoginInputType(type: LoginFieldType) -> InputFieldConfig {
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
}
