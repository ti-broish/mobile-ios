//
//  MenuCell.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 23.04.21.
//

import UIKit

final class MenuCell: TibTableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    func configure(_ item: MenuItem) {
        titleLabel.text = item.title
    }
}
