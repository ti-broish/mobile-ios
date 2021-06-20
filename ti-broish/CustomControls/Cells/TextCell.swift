//
//  TextCell.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 11.05.21.
//

import UIKit

final class TextCell: TibTableViewCell {
    
    @IBOutlet private (set) weak var textInputField: TextInputField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textInputField.textField.backgroundColor = .white
    }
    
    func markAsDisabled() {
        textInputField.textField.isEnabled = false
        textInputField.textField.backgroundColor = TibTheme().darkTextColor.withAlphaComponent(0.5)
    }
}
