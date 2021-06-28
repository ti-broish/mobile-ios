//
//  ViolationsTableViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 23.04.21.
//

import UIKit
import Combine

final class ViolationsTableViewController: BaseTableViewController {

    private let viewModel = ViolationsViewModel()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObservers()
        viewModel.start()
        
        baseViewModel = viewModel
        // TODO: - implement pagination
    }
    
    override func setupTableView() {
        super.setupTableView()
        tableView.registerCell(ViolationCell.self)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = TibTheme().darkTextColor
        tableView.setHeaderView(text: LocalizedStrings.Violations.title)
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

extension ViolationsTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.violations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: ViolationCell.cellIdentifier, for: indexPath)
        
        guard let cell = reusableCell as? ViolationCell else {
            return UITableViewCell()
        }
        
        cell.configure(viewModel.violations[indexPath.row], at: indexPath)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ViolationsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        showDetails(violation: viewModel.violations[indexPath.row])
    }
    
    // MARK: - Private methods (UITableViewDelegate)
    
    private func showDetails(violation: Violation) {
        let viewController = DetailsViewController.init(nibName: DetailsViewController.nibName, bundle: nil)
        viewController.viewModel.violation = violation

        navigationController?.pushViewController(viewController, animated: true)
    }
}

