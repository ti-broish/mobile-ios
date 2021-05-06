//
//  LoginViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 4/6/21.
//  
//

import UIKit

final class LoginViewController: BaseViewController {
    
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var emailInputField: CredentialInputField!
    @IBOutlet private weak var passwordInputField: CredentialInputField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registrationButton: UIButton!
    @IBOutlet private weak var resetPasswordButton: UIButton!
    
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
        
        emailInputField.configureTextField(config: viewModel.makeConfig(for: .email))
        emailInputField.textField.delegate = self
        
        passwordInputField.configureTextField(config: viewModel.makeConfig(for: .password))
        passwordInputField.textField.delegate = self
        
        loginButton.configureSolidButton(title: LocalizedStrings.Login.loginButton, theme: theme)
        registrationButton.configureButton(title: LocalizedStrings.Login.registrationButton, theme: theme, fontSize: 16.0)
        resetPasswordButton.configureButton(title: LocalizedStrings.Login.resetPasswordButton, theme: theme)
    }
    
    @IBAction private func didPressLoginButton(_ sender: UIButton) {
        // TODO: - validate email and password
        guard let email = emailInputField.textField.text, let password = passwordInputField.textField.text else {
            // TODO: - show invalid
            return
        }
        
        viewModel.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let isSuccessful):
                if isSuccessful {
                    self?.coordinator?.showHomeScreen()
                } else {
                    print("login failed: ???")
                }
            case .failure(let error):
                print("login failed: \(error)")
            }
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
