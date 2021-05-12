//
//  InputField.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 26.04.21.
//

import UIKit

class InputField: UIView, Configurable {
    
    typealias DataType = InputFieldData
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: TibTextField!
    
    var nibName: String {
        return ""
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
    
    func commonInit() {
        let views = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        guard let view = views?.first as? UIView else {
            return
        }
        
        view.frame = self.bounds
        addSubview(view)
    }
    
    func setupViews() {
        let theme = TibTheme()
        titleLabel.font = .regularFont(size: 14.0)
        titleLabel.textColor = theme.titleLabelTextColor
        
        textField.font = .regularFont(size: 16.0)
        textField.textColor = theme.textFieldColor
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
    }
    
    func configureWith(_ data: InputFieldData) {
        titleLabel.text = data.title
        
        if let _placeholderText = data.placeholderText {
            let theme = TibTheme()
            
            textField.attributedPlaceholder = NSAttributedString(
                string: _placeholderText,
                attributes: [.foregroundColor: theme.textFieldPlaceholderColor]
            )
        } else {
            textField.attributedPlaceholder = nil
        }
        
        configureTextFieldKeyboardType(inputFieldType: data.type)
    }
    
    // MARK: - Private methods
    
    private func configureTextFieldKeyboardType(inputFieldType: InputFieldType) {
        switch inputFieldType {
        case .email:
            textField.keyboardType = .emailAddress
        case .password:
            textField.keyboardType = .default
            textField.isSecureTextEntry = true
        case .phone:
            textField.keyboardType = .phonePad
        case .pin:
            textField.keyboardType = .decimalPad
        default:
            textField.keyboardType = .default
        }
    }
}
