//
//  MenuCell.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 23.04.21.
//

import UIKit

final class MenuCell: TibTableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = .regularFont(size: 16.0)
        titleLabel.textColor = TibTheme().textColor
    }
    
    func configure(_ item: MenuItem) {
        if item.type == .live {
            titleLabel.attributedText = item.title.makeLiveText(textColor: TibTheme().textColor)
        } else {
            titleLabel.text = item.title
        }
    }
}
