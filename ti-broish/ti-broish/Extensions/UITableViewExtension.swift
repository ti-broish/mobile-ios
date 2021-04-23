//
//  UITableViewExtension.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 24.04.21.
//

import UIKit

extension UITableView {
    
    func registerCell<T: TibTableViewCell>(_ cell: T.Type) {
        register(UINib(nibName: cell.nibName, bundle: nil), forCellReuseIdentifier: cell.cellIdentifier)
    }
}
