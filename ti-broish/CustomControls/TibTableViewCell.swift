//
//  TibTableViewCell.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 23.04.21.
//

import UIKit

protocol Cell {
    
    static var nibName: String { get }
    static var cellIdentifier: String { get }
    static var defaultCellHeight: CGFloat { get }
}

extension Cell {
    
    static var nibName: String {
        return "\(String(describing: self))"
    }
    
    static var cellIdentifier: String {
        return "\(String(describing: self))"
    }
    
    static var defaultCellHeight: CGFloat {
        assertionFailure("defaultCellHeight not implemented")
        return 0
    }
}

class TibTableViewCell: UITableViewCell, Cell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        selectionStyle = .none
    }
}
