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
    
    func setHeaderView(text: String) {
        let theme = TibTheme()
        let bounds = UIScreen.main.bounds
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: bounds.size.width, height: bounds.size.height * 0.1))
        label.textColor = theme.textColor
        label.font = .semiBoldFont(size: 22.0)
        label.text = text
        label.textAlignment = .center
        
        self.tableHeaderView = label
    }
}
