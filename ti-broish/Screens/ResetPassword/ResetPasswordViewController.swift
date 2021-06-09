//
//  ResetPasswordViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 23.04.21.
//

import UIKit

final class ResetPasswordViewController: BaseViewController {
    
    @IBOutlet private weak var emailInputField: CredentialInputField!
    @IBOutlet private weak var sendButton: UIButton!
    
    private let viewModel = ResetPasswordViewModel()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func applyTheme() {
        super.applyTheme()
        
        let theme = TibTheme()
        emailInputField.backgroundColor = theme.backgroundColor
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        self.title = LocalizedStrings.ResetPassword.title
        
        emailInputField.configureWith(viewModel.makeConfig(for: .email))
        emailInputField.textField.text = LocalStorage.Login().getEmail()
        emailInputField.textField.delegate = self
        
        let theme = TibTheme()
        sendButton.configureSolidButton(title: LocalizedStrings.ResetPassword.sendButton, theme: theme)
    }
    
    @IBAction private func handleSendButton(_ sender: UIButton) {
        guard let email = emailInputField.textField.text else {
            return
        }
        
        viewModel.resetPassword(email: email) { result in
            switch result {
            case .success():
                // TODO: - show toast
                print(LocalizedStrings.ResetPassword.message)
            case .failure(let error):
                // TODO: - show toast
                print("request password failed: \(error.localizedString)")
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension ResetPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        // TODO: - implement email validation
        return true
    }
}
