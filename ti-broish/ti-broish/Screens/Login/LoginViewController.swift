//
//  LoginViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 4/6/21.
//  
//

import UIKit

final class LoginViewController: BaseViewController {
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: LocalizedStrings.back,
            style: .plain,
            target: nil,
            action: nil
        )
    }
    
    override func applyTheme() {
        super.applyTheme()
    }
    
    // MARK: - Private methods
    
    @IBAction private func didPressLoginButton(_ sender: UIButton) {
        coordinator?.showHomeScreen()
    }
    
    @IBAction private func didPressRegistrationButton(_ sender: UIButton) {
        coordinator?.showRegistrationScreen()
    }
    
    @IBAction private func didPressResetPasswordButton(_ sender: UIButton) {
        coordinator?.showResetPasswordScreen()
    }
}
