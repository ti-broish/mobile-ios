//
//  ViolationCell.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 13.06.21.
//

import UIKit

final class ViolationCell: TibTableViewCell {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var sectionLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var arrowImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stackView.spacing = 8.0
        sectionLabel.numberOfLines = 0
        locationLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 3
        
        statusLabel.font = .semiBoldFont(size: 14.0)
        arrowImageView.image = UIImage(named: SharedAssetsConfig.arrowNext)
    }
    
    func configure(_ model: Violation, at indexPath: IndexPath) {
        let rowIndex: String
        
        if model.sections != nil {
            rowIndex = ""
            assertionFailure("violation sections are not handled")
        } else {
            sectionLabel.isHidden = true
            locationLabel.isHidden = true
            rowIndex = "\(indexPath.row + 1). "
        }
        
        descriptionLabel.attributedText = StringUtils.makeAttributedText(
            prefix: "\(rowIndex)\(LocalizedStrings.SendInputField.description)",
            text: model.description,
            textColor: TibTheme().darkTextColor
        )
        
        statusLabel.text = model.statusLocalized
        
        if let statusColor = model.statusColor {
            statusLabel.textColor = StringUtils.stringToColor(hex: statusColor)
        } else {
            statusLabel.textColor = StringUtils.stringToColor(hex: model.status.colorString)
        }
    }
}
