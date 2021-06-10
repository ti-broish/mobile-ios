//
//  SendProtocolViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 23.04.21.
//

import UIKit

final class SendProtocolViewController: BaseViewController {
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func applyTheme() {
        super.applyTheme()
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        navigationItem.configureBackButton()
    }
}
