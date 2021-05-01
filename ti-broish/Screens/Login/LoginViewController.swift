//
//  LoginViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 4/6/21.
//  
//

import UIKit
import Toast_Swift

final class LoginViewController: BaseViewController {
    
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var emailInputField: CredentialInputField!
    @IBOutlet private weak var passwordInputField: CredentialInputField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registrationButton: UIButton!
    @IBOutlet private weak var resetPasswordButton: UIButton!

    private var firebase = FirebaseClient()
    private var viewModel = LoginViewModel()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func applyTheme() {
        super.applyTheme()
        
        emailInputField.backgroundColor = theme.backgroundColor
        passwordInputField.backgroundColor = theme.backgroundColor
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: LocalizedStrings.back,
            style: .plain,
            target: nil,
            action: nil
        )
        
        emailInputField.configureTextField(config: viewModel.makeConfigForLoginInputType(type: .email))
        emailInputField.textField.delegate = self
        
        passwordInputField.configureTextField(config: viewModel.makeConfigForLoginInputType(type: .password))
        passwordInputField.textField.delegate = self
        
        loginButton.configureSolidButton(title: LocalizedStrings.Login.loginButton, theme: theme)
        registrationButton.configureButton(title: LocalizedStrings.Login.registrationButton, theme: theme, fontSize: 16.0)
        resetPasswordButton.configureButton(title: LocalizedStrings.Login.resetPasswordButton, theme: theme)
    }
    
    @IBAction private func didPressLoginButton(_ sender: UIButton) {
        let email = emailInputField.textField.text!
        let password = passwordInputField.textField.text!
        if !email.isEmpty && !password.isEmpty {
            self.firebase.login(email: email, password: password, completionHandler: { [weak self] result in
                guard let strongSelf = self else { return }

                switch result {
                case .success(let user):
                    // TODO: get user data from ti-broish API
                    dump(user)
                    strongSelf.coordinator?.showHomeScreen()
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
                    strongSelf.view.makeToast(errorMessage)
                }
            })
        } else {
            self.navigationController?.view.makeToast("Моля въведете потребителско име и парола")
        }
    }
    
    @IBAction private func didPressRegistrationButton(_ sender: UIButton) {
        coordinator?.showRegistrationScreen()
    }
    
    @IBAction private func didPressResetPasswordButton(_ sender: UIButton) {
        coordinator?.showResetPasswordScreen()
    }
}

// MARK: - Factory

extension LoginViewController {
    
    static func create() -> BaseViewController {
        let controller = LoginViewController()
        return controller
    }
    
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailInputField.textField:
            textField.resignFirstResponder()
        case passwordInputField.textField:
            textField.resignFirstResponder()
        default:
            break
        }
        
        return true
    }
}
