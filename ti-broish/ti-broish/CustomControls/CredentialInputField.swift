//
//  CredentialInputField.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 24.04.21.
//

import UIKit

enum CredentialInputFieldType {
    
    case email, password
}

final class CredentialInputField: UIView {
    
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var mTextField: UITextField!
    @IBOutlet private weak var separatorView: UIView!
    
    var textField: UITextField {
        return mTextField
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        setupViews()
    }
    
    func configure(
        type: CredentialInputFieldType,
        textFieldDelegate: UITextFieldDelegate,
        title: String,
        placeholder: String? = nil
    )
    {
        switch type {
        case .email:
            setupInputField(
                keyboardType: .emailAddress,
                textFieldDelegate: textFieldDelegate,
                title: title,
                placeholder: placeholder
            )
        case .password:
            setupInputField(
                keyboardType: .default,
                textFieldDelegate: textFieldDelegate,
                title: title,
                placeholder: placeholder,
                isSecureTextEntry: true
            )
        }
    }
    
    // MARK: - Private methods
    
    private func commonInit() {
        let views = Bundle.main.loadNibNamed("CredentialInputField", owner: self, options: nil)
        guard let view = views?.first as? UIView else {
            return
        }
        
        view.frame = self.bounds
        addSubview(view)
    }
    
    private func setupViews() {
        let theme = TibTheme()
        view.backgroundColor = .clear
        
        titleLabel.font = .regularFont(size: 14.0)
        titleLabel.textColor = theme.titleLabelTextColor
        
        mTextField.font = .regularFont(size: 16.0)
        mTextField.textColor = theme.textFieldColor
        
        separatorView.backgroundColor = theme.tableViewSeparatorColor
    }
    
    private func setupInputField(
        keyboardType: UIKeyboardType,
        textFieldDelegate: UITextFieldDelegate,
        title: String,
        placeholder: String?,
        isSecureTextEntry: Bool = false
    )
    {
        titleLabel.text = title
        
        if let _placeholder = placeholder {
            let theme = TibTheme()
            mTextField.attributedPlaceholder = NSAttributedString(
                string: _placeholder,
                attributes: [.foregroundColor: theme.textFieldPlaceholderColor]
            )
        }
        
        mTextField.delegate = textFieldDelegate
        mTextField.keyboardType = keyboardType
        mTextField.isSecureTextEntry = isSecureTextEntry
    }
}
