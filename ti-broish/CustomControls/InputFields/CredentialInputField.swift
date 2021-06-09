//
//  CredentialInputField.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 24.04.21.
//

import UIKit

final class CredentialInputField: InputField {
    
    @IBOutlet private weak var separatorView: UIView!
    
    override var nibName: String {
        return "CredentialInputField"
    }
    
    override func setupViews() {
        super.setupViews()
        
        let theme = TibTheme()
        view.backgroundColor = .clear
        separatorView.backgroundColor = theme.tableViewSeparatorColor
    }
}
