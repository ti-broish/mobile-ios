//
//  ProtocolCell.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 11.06.21.
//

import UIKit

final class ProtocolCell: TibTableViewCell {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var arrowImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stackView.spacing = 8.0
        titleLabel.numberOfLines = 0
        
        locationLabel.numberOfLines = 0
        locationLabel.textColor = .darkTextColor
        locationLabel.font = .regularFont(size: 14.0)
        
        statusLabel.font = .semiBoldFont(size: 14.0)
        arrowImageView.image = UIImage(named: SharedAssetsConfig.arrowNext)
    }
    
    func configure(_ model: Protocol, at indexPath: IndexPath) {
        titleLabel.attributedText = StringUtils.makeAttributedText(
            prefix: "\(indexPath.row + 1). \(LocalizedStrings.Protocols.section): ",
            text: model.section.code,
            textColor: .darkTextColor
        )
        
        locationLabel.text = model.section.place
        statusLabel.text = model.statusLocalized
        
        if let statusColor = model.statusColor {
            statusLabel.textColor = StringUtils.stringToColor(hex: statusColor)
        } else {
            statusLabel.textColor = StringUtils.stringToColor(hex: model.status.colorString)
        }
    }
}
