//
//  SearchCell.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 12.05.21.
//

import UIKit

final class SearchCell: TibTableViewCell, Configurable {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
        let theme = TibTheme()
        titleLabel.font = .regularFont(size: 14.0)
        titleLabel.textColor = theme.titleLabelTextColor
        titleLabel.numberOfLines = 0
    }
    
    func configureWith(_ data: SearchItem) {
        switch data.type {
        case .organization:
            titleLabel.text = "\(data.id) \(data.name)"
        default:
            titleLabel.text = "\(data.id)"
        }
    }
}
