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
    
    private let validator = Validator()
    let viewModel = LoginViewModel()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func applyTheme() {
        super.applyTheme()
        
        let theme = TibTheme()
        emailInputField.backgroundColor = theme.backgroundColor
        passwordInputField.backgroundColor = theme.backgroundColor
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        navigationItem.configureBackButton()
        
        logoImageView.image = UIImage(named: SharedAssetsConfig.logo)
        
        emailInputField.configureWith(viewModel.makeConfig(for: .email))
        emailInputField.textField.text = LocalStorage.Login().getEmail()
        emailInputField.textField.delegate = self
        
        passwordInputField.configureWith(viewModel.makeConfig(for: .password))
        passwordInputField.textField.delegate = self
        
        let theme = TibTheme()
        loginButton.configureSolidButton(title: LocalizedStrings.Login.loginButton, theme: theme)
        registrationButton.configureButton(title: LocalizedStrings.Login.registrationButton, theme: theme, fontSize: 16.0)
        resetPasswordButton.configureButton(title: LocalizedStrings.Login.resetPasswordButton, theme: theme)
    }
    
    @IBAction private func didPressLoginButton(_ sender: UIButton) {
        guard let email = emailInputField.textField.text, validator.isValidEmail(email) else {
            // TODO: - show invalid email
            return
        }
        
        guard let password = passwordInputField.textField.text, validator.isValidPassword(password) else {
            // TODO: - show invalid password
            return
        }
        
        viewModel.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let isSuccessful):
                if isSuccessful {
                    self?.viewModel.coordinator?.showHomeScreen()
                } else {
                    print("login failed: ???")
                }
            case .failure(let error):
                // TODO: - show toast
                print("login failed: \(error.localizedString)")
            }
        }
    }
    
    @IBAction private func didPressRegistrationButton(_ sender: UIButton) {
        viewModel.coordinator?.showRegistrationScreen()
    }
    
    @IBAction private func didPressResetPasswordButton(_ sender: UIButton) {
        viewModel.coordinator?.showResetPasswordScreen()
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
