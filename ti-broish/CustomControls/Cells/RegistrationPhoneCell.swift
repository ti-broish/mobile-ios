//
//  RegistrationPhoneCell.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 29.06.21.
//

import UIKit

final class RegistrationPhoneCell: TibTableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private (set) weak var codeButton: UIButton!
    @IBOutlet private (set) weak var numberTextField: TibTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    func configureWith(_ data: InputFieldConfig, countryCode: CountryPhoneCode) {
        titleLabel.setText(data.title, isRequired: data.isRequired)
        codeButton.setTitle(countryCode.code, for: .normal)
        
        if let text = data.data as? String {
            numberTextField.text = text
        } else if let placeholderText = data.placeholderText {
            let theme = TibTheme()
            
            if data.data == nil {
                numberTextField.text = nil
            }
            
            numberTextField.attributedPlaceholder = NSAttributedString(
                string: placeholderText,
                attributes: [.foregroundColor: theme.placeholderColor]
            )
        } else {
            numberTextField.text = nil
            numberTextField.attributedPlaceholder = nil
        }
    }
    
    // MARK: - Private methods
    
    func setupViews() {
        let theme = TibTheme()
        backgroundColor = theme.backgroundColor
        
        titleLabel.font = .regularFont(size: 14.0)
        titleLabel.textColor = theme.textColor
        
        codeButton.titleLabel?.font = .regularFont(size: 16.0)
        codeButton.setTitleColor(theme.textColor, for: .normal)
        codeButton.backgroundColor = .white
        codeButton.setBorder(radius: 0.0, width: 1.0, color: theme.backgroundColor)
        
        numberTextField.font = .regularFont(size: 16.0)
        numberTextField.textColor = theme.textColor
        numberTextField.autocorrectionType = .no
        numberTextField.autocapitalizationType = .none
        numberTextField.keyboardType = .numbersAndPunctuation
        numberTextField.backgroundColor = .white
        numberTextField.setBorder(radius: 0.0, width: 1.0, color: theme.backgroundColor)
    }
}
