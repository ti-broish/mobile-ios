//
//  ResetPasswordViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 23.04.21.
//

import UIKit

final class ResetPasswordViewController: BaseViewController {
    
    // MARK: - View lifecycle
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func applyTheme() {
        super.applyTheme()
    }
}
