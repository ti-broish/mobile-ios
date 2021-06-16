//
//  SendProtocolViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 23.04.21.
//

import UIKit

final class SendProtocolViewController: BaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func applyTheme() {
        super.applyTheme()
        
        let theme = TibTheme()
        tableView.backgroundColor = theme.backgroundColor
    }
    
    // MARK: - Private methods
    
    private func setupTableView() {
        tableView.registerCell(TextCell.self)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 86.0
        tableView.setHeaderView(text: LocalizedStrings.Menu.sendProtocol)
        tableView.tableFooterView = UIView()
    }
    
    private func setupViews() {
//        navigationItem.configureTitleView()
        setupTableView()
    }
}

// MARK: - UITableViewDataSource

extension SendProtocolViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1//viewModel.protocols.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: TextCell.cellIdentifier, for: indexPath)
        
        guard let cell = reusableCell as? TextCell else {
            return UITableViewCell()
        }
        
        //cell.configure(viewModel.protocols[indexPath.row], at: indexPath)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SendProtocolViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //showDetails(protocolItem: viewModel.protocols[indexPath.row])
    }
    
    // MARK: - Private methods (UITableViewDelegate)
    
//    private func showDetails(protocolItem: Protocol) {
//        let viewController = DetailsViewController.init(nibName: DetailsViewController.nibName, bundle: nil)
//        viewController.viewModel.protocolItem = protocolItem
//
//        navigationController?.pushViewController(viewController, animated: true)
//    }
}
