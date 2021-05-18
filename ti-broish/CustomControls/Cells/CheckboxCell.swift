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
    
    @IBOutlet private (set) weak var checkboxButton: UIButton!
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
        
        checkboxButton.layer.borderWidth = 2.0
        checkboxButton.layer.cornerRadius = 4.0
        checkboxButton.layer.borderColor = UIColor.primaryColor.cgColor
        checkboxButton.setTitleColor(.primaryColor, for: .normal)
        
        titleLabel.font = .regularFont(size: 14.0)
        titleLabel.textColor = theme.titleLabelTextColor
        titleLabel.numberOfLines = 0
    }
    
    func configureWith(_ data: InputFieldData) {
        titleLabel.setText(data.title, isRequired: data.isRequired)
        
        if let _state = data.data as? CheckboxState {
            state = _state
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

