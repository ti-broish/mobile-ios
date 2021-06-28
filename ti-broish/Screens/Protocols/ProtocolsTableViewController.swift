//
//  ProtocolsTableViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 23.04.21.
//

import UIKit
import Combine

final class ProtocolsTableViewController: BaseTableViewController {

    private let viewModel = ProtocolsViewModel()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObservers()
        viewModel.start()
        // TODO: - implement pagination
    }
    
    override func setupTableView() {
        super.setupTableView()
        tableView.registerCell(ProtocolCell.self)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = TibTheme().darkTextColor
        tableView.setHeaderView(text: LocalizedStrings.Protocols.title)
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        setupTableView()
    }
    
    private func observeReloadDataPublisher() {
        reloadDataSubscription = viewModel
            .reloadDataPublisher
            .sink(
                receiveCompletion: { [unowned self] _ in
                    tableView.reloadData()
                    viewModel.loadingPublisher.send(false)
                },
                receiveValue: { [unowned self] error in
                    if let error = error {
                        print("reload data failed \(error)")
                    }
                    
                    tableView.reloadData()
                    viewModel.loadingPublisher.send(false)
                })
    }
    
    private func observeLoadingPublisher() {
        loadingSubscription = viewModel.loadingPublisher.sink(receiveValue: { [unowned self] isLoading in
            isLoading ? view.showLoading() : view.hideLoading()
        })
    }
    
    private func addObservers() {
        observeReloadDataPublisher()
        observeLoadingPublisher()
    }
}

// MARK: - UITableViewDataSource

extension ProtocolsTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.protocols.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: ProtocolCell.cellIdentifier, for: indexPath)
        
        guard let cell = reusableCell as? ProtocolCell else {
            return UITableViewCell()
        }
        
        cell.configure(viewModel.protocols[indexPath.row], at: indexPath)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ProtocolsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        showDetails(protocolItem: viewModel.protocols[indexPath.row])
    }
    
    // MARK: - Private methods (UITableViewDelegate)
    
    private func showDetails(protocolItem: Protocol) {
        let viewController = DetailsViewController.init(nibName: DetailsViewController.nibName, bundle: nil)
        viewController.viewModel.protocolItem = protocolItem

        navigationController?.pushViewController(viewController, animated: true)
    }
}
