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
}

extension Cell {
    
    static var nibName: String {
        return "\(String(describing: self))"
    }
    
    static var cellIdentifier: String {
        return "\(String(describing: self))"
    }
}

class TibTableViewCell: UITableViewCell, Cell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}
