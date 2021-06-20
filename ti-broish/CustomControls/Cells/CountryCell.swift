//
//  CountryCell.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 20.06.21.
//

import UIKit

final class CountryCell: TibTableViewCell {
    
    @IBOutlet private weak var countryView: UIView!
    @IBOutlet private weak var countryButton: UIButton!
    @IBOutlet private weak var countryLabel: UILabel!
    
    @IBOutlet private weak var abroadCountryView: UIView!
    @IBOutlet private weak var abroadCountryButton: UIButton!
    @IBOutlet private weak var abroadCountryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let theme = TibTheme()
        countryView.backgroundColor = theme.backgroundColor
        countryLabel.text = LocalizedStrings.Violations.country
        countryLabel.font = .regularFont(size: 14.0)
        countryLabel.textColor = theme.darkTextColor
        
        abroadCountryView.backgroundColor = theme.backgroundColor
        abroadCountryLabel.text = LocalizedStrings.Violations.abroad
        abroadCountryLabel.font = .regularFont(size: 14.0)
    }
}
