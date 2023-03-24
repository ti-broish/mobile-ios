//
//  MenuViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 4/6/21.
//  
//

import UIKit

protocol MenuViewControllerDelegate: AnyObject {
    
    func didSelectMenuItem(_ menuItem: MenuItem, sender: MenuViewController)
}

final class MenuViewController: BaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel = MenuViewModel()
    weak var delegate: MenuViewControllerDelegate?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func applyTheme() {
        super.applyTheme()
        
        self.view.backgroundColor = .white
    }
    
    // MARK: - Private methods
    
    private func setupTableView() {
        let theme = TibTheme()
        tableView.registerCell(MenuCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorColor = theme.tableViewSeparatorColor
        tableView.rowHeight = 44.0
        tableView.tableFooterView = UIView()
    }
}

// MARK: - UITableViewDataSource

extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.cellIdentifier, for: indexPath) as? MenuCell else {
            return UITableViewCell()
        }
        
        cell.configure(viewModel.menuItems[indexPath.row])
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.didSelectMenuItem(viewModel.menuItems[indexPath.row], sender: self)
    }
}
