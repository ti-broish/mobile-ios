//
//  ResetPasswordViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 23.04.21.
//

import UIKit
import Combine

final class ResetPasswordViewController: BaseViewController {
    
    @IBOutlet private weak var emailInputField: CredentialInputField!
    @IBOutlet private weak var sendButton: UIButton!
    
    private let viewModel = ResetPasswordViewModel()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.start()
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
        
        emailInputField.configureWith(viewModel.data[ResetPasswordFieldType.email.rawValue])
        emailInputField.textField.text = LocalStorage.Login().getEmail()
        emailInputField.textField.delegate = self
        
        let theme = TibTheme()
        sendButton.configureSolidButton(title: LocalizedStrings.Buttons.send, theme: theme)
    }
    
    @IBAction private func handleSendButton(_ sender: UIButton) {
        guard
            let email = emailInputField.textField.text,
            viewModel.validator.validate(email: email)
        else {
            view.showMessage(LocalizedStrings.Errors.invalidEmail)
            return
        }
        
        view.showLoading()
        viewModel.resetPassword(email: email) { [unowned self] result in
            switch result {
            case .success():
                view.showMessage(LocalizedStrings.ResetPassword.message)
                viewModel.updateFieldValue(nil, at: IndexPath(row: 0, section: 0))
                emailInputField.textField.text = nil
                view.hideLoading()
            case .failure(let error):
                print("request password failed: \(error)")
                view.hideLoading()
                view.showMessage(error.localizedString)
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension ResetPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
