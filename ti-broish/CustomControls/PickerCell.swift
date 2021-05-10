//
//  PickerCell.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 11.05.21.
//

import UIKit

final class PickerCell: TibTableViewCell, Configurable {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var arrowImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
        let theme = TibTheme()
        titleLabel.font = .regularFont(size: 14.0)
        titleLabel.textColor = theme.titleLabelTextColor
        titleLabel.numberOfLines = 0
        
        valueLabel.font = .regularFont(size: 16.0)
        valueLabel.textColor = theme.textFieldColor
        valueLabel.numberOfLines = 0
    }
    
    func configureWith(_ data: InputFieldConfig) {
        titleLabel.text = data.title
        valueLabel.text = ""
    }
}
