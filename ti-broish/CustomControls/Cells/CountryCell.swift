//
//  CountryCell.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 20.06.21.
//

import UIKit

enum CountryType: Int {
    case defaultCountry, abroad
}

protocol CountryCellDelegate: AnyObject {
    func didChangeCountryType(_ type: CountryType, sender: CountryCell)
}

final class CountryCell: TibTableViewCell {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var countryView: UIView!
    @IBOutlet private weak var countryButton: UIButton!
    @IBOutlet private weak var countryLabel: UILabel!
    
    @IBOutlet private weak var abroadCountryView: UIView!
    @IBOutlet private weak var abroadCountryButton: UIButton!
    @IBOutlet private weak var abroadCountryLabel: UILabel!
 
    weak var delegate: CountryCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let theme = TibTheme()
        backgroundColor = theme.backgroundColor
        stackView.backgroundColor = theme.backgroundColor
        
        countryView.backgroundColor = theme.backgroundColor
        configureLabel(countryLabel, text: LocalizedStrings.Violations.country, theme: theme)
        configureCheckbox(button: countryButton)
        
        abroadCountryView.backgroundColor = theme.backgroundColor
        configureLabel(abroadCountryLabel, text: LocalizedStrings.Violations.abroad, theme: theme)
        configureCheckbox(button: abroadCountryButton)
        
        changeCountry(type: .defaultCountry)
    }
    
    func configure(countryType: CountryType) {
        switch countryType {
        case .defaultCountry:
            countryButton.setTitle(CheckboxState.checked.stringValue, for: .normal)
            abroadCountryButton.setTitle(CheckboxState.unchecked.stringValue, for: .normal)
        case .abroad:
            countryButton.setTitle(CheckboxState.unchecked.stringValue, for: .normal)
            abroadCountryButton.setTitle(CheckboxState.checked.stringValue, for: .normal)
        }
    }
    
    // MARK: - Private methods
    
    private func configureLabel(_ label: UILabel, text: String, theme: TibTheme) {
        label.text = text
        label.font = .regularFont(size: 14.0)
        label.textColor = theme.textColor
    }
    
    private func configureCheckbox(button: UIButton) {
        button.setBorder(width: 2.0, color: .primaryColor)
        button.setTitleColor(.primaryColor, for: .normal)
    }
    
    private func changeCountry(type: CountryType) {
        configure(countryType: type)
        delegate?.didChangeCountryType(type, sender: self)
    }
    
    @IBAction private func handleCountryButton(_ sender: UIButton) {
        changeCountry(type: .defaultCountry)
    }
    
    @IBAction private func handleAbroadCountryButton(_ sender: UIButton) {
        changeCountry(type: .abroad)
    }
}
