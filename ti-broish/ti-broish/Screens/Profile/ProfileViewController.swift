//
//  ProfileViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 4/13/21.
//  
//

import UIKit

final class ProfileViewController: BaseViewController {
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func applyTheme() {
        super.applyTheme()
    }
    
    // MARK: - Private methods
    
    @IBAction private func didPressLoginButton(_ sender: UIButton) {
        let controller = LoginViewController(nibName: LoginViewController.nibName, bundle: nil)
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
