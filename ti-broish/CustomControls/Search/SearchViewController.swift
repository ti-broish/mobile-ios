//
//  SearchViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 12.05.21.
//

import UIKit
import Combine

protocol SearchViewControllerDelegate: AnyObject {
    
    func didFinishSearching(value: SearchItem?, sender: SearchViewController)
}

final class SearchViewController: UIViewController, TibViewControllable {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel = SearchViewModel()
    private var reloadDataSubscription: AnyCancellable?
    
    var selectedItem: SearchItem?
    var parentCellIndexPath: IndexPath?
    
    weak var delegate: SearchViewControllerDelegate?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDoneBarButton()
        setupTableView()
        setupSearchController()
        applyTheme()
        addObservers()
        viewModel.getOrganizations()
    }
    
    func applyTheme() {
        
    }
    
    // MARK: - Private methods
    
    @objc private func handleDoneBarButton(_ sender: UIBarButtonItem) {
        reloadDataSubscription?.cancel()
        delegate?.didFinishSearching(value: selectedItem, sender: self)
    }
    
    private func setupDoneBarButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: LocalizedStrings.Search.doneButton,
            style: .plain,
            target: self,
            action: #selector(handleDoneBarButton)
        )
    }
    
    private func setupTableView() {
        tableView.registerCell(SearchCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 44.0
        tableView.tableFooterView = UIView()
    }
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = LocalizedStrings.Search.searchBarPlaceholder
        navigationItem.searchController = searchController
        definesPresentationContext = true
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

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.cellIdentifier, for: indexPath) as? SearchCell else {
            return UITableViewCell()
        }
        
        let item = viewModel.items[indexPath.row]
        cell.configureWith(item)
        cell.accessoryType = item.id == selectedItem?.id ? .checkmark : .none
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedItem = viewModel.items[indexPath.row]
        
        tableView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        viewModel.filter(by: text)
        tableView.reloadData()
    }
}
