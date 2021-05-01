//
//  RegistrationTextCell.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 26.04.21.
//

import UIKit

final class RegistrationTextCell: TibTableViewCell {
    
    @IBOutlet private (set) weak var textInputField: TextInputField!
    
    static var defaultCellHeight: CGFloat {
        return 86.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textInputField.textField.backgroundColor = .white
    }
}
