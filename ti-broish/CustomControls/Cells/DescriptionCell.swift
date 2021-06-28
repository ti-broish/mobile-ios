//
//  DescriptionCell.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 24.06.21.
//

import UIKit

final class DescriptionCell: TibTableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private (set) weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let theme = TibTheme()
        backgroundColor = theme.backgroundColor
        
        titleLabel.font = .regularFont(size: 14.0)
        titleLabel.textColor = theme.textColor
        
        textView.font = .regularFont(size: 16.0)
        textView.textColor = theme.textColor
        textView.backgroundColor = .white
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
    }
    
    func configureWith(_ data: InputFieldConfig) {
        titleLabel.setText(data.title, isRequired: data.isRequired)
        
        let theme = TibTheme()
        
        if let text = data.data as? String {
            textView.textColor = theme.textColor
            textView.text = text
        } else {
            textView.textColor = theme.darkTextColor
            textView.text = data.placeholderText
        }
    }
}
