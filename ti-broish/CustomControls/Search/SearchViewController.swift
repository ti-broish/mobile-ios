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
    private var loadingSubscription: AnyCancellable?
    
    let viewModel = SearchViewModel()
    var selectedItem: SearchItem?
    var parentCellIndexPath: IndexPath?
    var reloadDataSubscription: AnyCancellable?
    
    weak var delegate: SearchViewControllerDelegate?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDoneBarButton()
        setupTableView()
        setupSearchController()
        applyTheme()
        addObservers()
        viewModel.start()
    }
    
    func applyTheme() {
        
    }
    
    // MARK: - Private methods
    
    @objc private func handleDoneBarButton(_ sender: UIBarButtonItem) {
        reloadDataSubscription?.cancel()
        delegate?.didFinishSearching(value: selectedItem, sender: self)
    }
    
    private func setupDoneBarButton() {
        let barButton = UIBarButtonItem(
            title: LocalizedStrings.Search.doneButton,
            style: .plain,
            target: self,
            action: #selector(handleDoneBarButton)
        )
        
        barButton.setTitleTextAttributes([.foregroundColor: UIColor.primaryColor], for: .normal)
        
        self.navigationItem.rightBarButtonItem = barButton
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
    
    private func observeReloadDataPublisher() {
        reloadDataSubscription = viewModel
            .reloadDataPublisher
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [unowned self] error in
                    if let error = error {
                        print("reload data failed \(error)")
                    }
                    
                    tableView.reloadData()
                    view.hideLoading()
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

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: SearchCell.cellIdentifier, for: indexPath)
        guard let cell = reusableCell as? SearchCell else {
            return UITableViewCell()
        }
        
        let item = viewModel.items[indexPath.row]
        cell.configureWith(item)
        markAsSelected(item: item, cell: cell)
        
        return cell
    }
    
    // MARK: - Private methods (UITableViewDataSource)
    
    private func markAsSelected(item: SearchItem, cell: SearchCell) {
        switch item.type {
        case .country, .electionRegion, .municipality, .cityRegion:
            cell.accessoryType = item.code == selectedItem?.code ? .checkmark : .none
        case .organization, .town, .section:
            cell.accessoryType = item.id == selectedItem?.id ? .checkmark : .none
        default:
            cell.accessoryType = .none
        }
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
