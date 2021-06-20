//
//  CheckboxCell.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 18.05.21.
//

import UIKit

enum CheckboxState {
    case unchecked, checked
    
    var stringValue: String {
        switch self {
        case .unchecked:
            return ""
        case .checked:
            return "\u{2713}" // tick
        }
    }
}

protocol CheckboxCellDelegate: AnyObject {
    
    func didChangeCheckboxState(state: CheckboxState, sender: CheckboxCell)
}

final class CheckboxCell: TibTableViewCell, Configurable {
    
    @IBOutlet private weak var checkboxButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private var state: CheckboxState = .unchecked {
        didSet {
            checkboxButton.setTitle(state.stringValue, for: .normal)
        }
    }
    
    weak var delegate: CheckboxCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
        
        let theme = TibTheme()

        checkboxButton.setBorder(width: 2.0, color: .primaryColor)
        checkboxButton.setTitleColor(.primaryColor, for: .normal)
        
        titleLabel.font = .regularFont(size: 14.0)
        titleLabel.textColor = theme.textColor
        titleLabel.numberOfLines = 0
    }
    
    func configureWith(_ data: InputFieldConfig) {
        titleLabel.setText(data.title, isRequired: data.isRequired)
        
        if let checkboxState = data.data as? CheckboxState {
            self.state = checkboxState
        }
    }
    
    // MARK: - Private methods
    
    @IBAction private func chengeCheckboxState(_ sender: UIButton) {
        switch state {
        case .unchecked:
            state = .checked
        case .checked:
            state = .unchecked
        }
        
        delegate?.didChangeCheckboxState(state: state, sender: self)
    }
}

