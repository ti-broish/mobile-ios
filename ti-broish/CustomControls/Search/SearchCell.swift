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
        
        backgroundColor = .white
        tintColor = .primaryColor
        
        titleLabel.font = .regularFont(size: 14.0)
        titleLabel.textColor = TibTheme().textColor
        titleLabel.numberOfLines = 0
    }
    
    func configureWith(_ data: SearchItem) {
        switch data.type {
        case .electionRegion, .section, .country, .phoneCode:
            titleLabel.text = "\(data.code) \(data.name)"
        case .municipality, .town, .cityRegion:
            titleLabel.text = data.name
        case .organization:
            titleLabel.text = "\(data.id) \(data.name)"
        default:
            titleLabel.text = "\(data.id)"
        }
    }
}
