//
//  InputField.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 26.04.21.
//

import UIKit

class InputField: UIView, Configurable {
    
    typealias DataType = InputFieldConfig
    
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
        view.backgroundColor = theme.backgroundColor
        
        titleLabel.font = .regularFont(size: 14.0)
        titleLabel.textColor = theme.textColor
        
        textField.font = .regularFont(size: 16.0)
        textField.textColor = theme.textColor
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
    }
    
    func configureWith(_ data: InputFieldConfig) {
        titleLabel.setText(data.title, isRequired: data.isRequired)
        
        if let text = data.data as? String {
            textField.text = text
        } else if let section = data.data as? Section {
            textField.text = section.id
        } else if let placeholderText = data.placeholderText {
            let theme = TibTheme()
            
            if data.data == nil {
                textField.text = nil
            }
            
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholderText,
                attributes: [.foregroundColor: theme.placeholderColor]
            )
        } else {
            textField.text = nil
            textField.attributedPlaceholder = nil
        }
        
        configureTextFieldKeyboardType(inputFieldType: data.type)
    }
    
    func enableTextField() {
        textField.isEnabled = true
        textField.textAlignment = .natural
    }
    
    func disableTextField() {
        textField.isEnabled = false
        textField.textAlignment = .center
    }
    
    func configureSectionNumber(section: Section, data: InputFieldConfig) {
        titleLabel.setText(data.title, isRequired: data.isRequired)
        disableTextField()
        
        textField.text = section.id
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
            textField.keyboardType = .numbersAndPunctuation
        case .pin:
            textField.keyboardType = .numbersAndPunctuation
        default:
            textField.keyboardType = .default
        }
    }
}
