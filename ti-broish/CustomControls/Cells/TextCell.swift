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
    
    func configureWith(_ data: InputFieldConfig) {
        let fieldType = data.dataType as! SendFieldType
        
        if fieldType == .sectionNumber {
            if let item = data.data as? SearchItem,
               let section = item.data as? Section
            {
                textInputField.configureSectionNumber(section: section, data: data)
            } else {
                textInputField.configureWith(data)
                textInputField.disableTextField()
            }
        } else {
            textInputField.configureWith(data)
        }
    }
    
    func markAsDisabled() {
        textInputField.textField.isEnabled = false
        textInputField.textField.backgroundColor = TibTheme().darkTextColor.withAlphaComponent(0.5)
    }
}
