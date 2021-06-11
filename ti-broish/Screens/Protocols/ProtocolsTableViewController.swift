//
//  ProtocolsTableViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 23.04.21.
//

import UIKit
import Combine

final class ProtocolsTableViewController: BaseViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel = ProtocolsViewModel()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObservers()
        viewModel.start()
        // TODO: - implement pagination
    }
    
    // MARK: - Private methods
    
    private func setupTableView() {
        tableView.registerCell(ProtocolCell.self)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .grayTextColor
        tableView.rowHeight = 86.0
        tableView.tableFooterView = UIView()
    }
    
    private func setupViews() {
        setupTableView()
    }
    
    private func addObservers() {
        reloadDataSubscription = viewModel
            .reloadDataPublisher
            .sink(
                receiveCompletion: { [unowned self] error in
                    print("reload data failed \(error)")
                    tableView.reloadData()
                },
                receiveValue: { [unowned self] _ in
                    tableView.reloadData()
                })
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

extension ProtocolsTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        if viewModel.data[indexPath.row].isPickerField {
//            showSearchController(for: indexPath)
//        }
    }
    
    // MARK: - Private methods (UITableViewDelegate)
    
//    private func showSearchController(for indexPath: IndexPath) {
//        let controller = SearchViewController.init(nibName: SearchViewController.nibName, bundle: nil)
//        controller.delegate = self
//        controller.parentCellIndexPath = indexPath
//        controller.selectedItem = viewModel.data[indexPath.row].data as? SearchItem
//
//        let navController = UINavigationController(rootViewController: controller)
//        self.present(navController, animated: true)
//    }
}

