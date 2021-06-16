//
//  SendProtocolViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 23.04.21.
//

import UIKit

final class SendProtocolViewController: BaseTableViewController {
    
    private let viewModel = SendProtocolViewModel()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.start()
    }
    
    override func setupTableView() {
        super.setupTableView()
        tableView.registerCell(TextCell.self)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.setHeaderView(text: LocalizedStrings.Menu.sendProtocol)
        tableView.tableFooterView = addSendButtonAsTableFooterView()
    }
    
    override func updateTextInputFieldValue(_ value: AnyObject?, at indexPath: IndexPath) {
        viewModel.updateFieldValue(value, at: indexPath)
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        navigationItem.configureTitleView()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SendProtocolSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? viewModel.data.count : viewModel.pictures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SendProtocolSection.data.rawValue {
            let reusableCell = tableView.dequeueReusableCell(withIdentifier: TextCell.cellIdentifier, for: indexPath)
            
            guard let textCell = reusableCell as? TextCell else {
                return UITableViewCell()
            }
            
            textCell.textInputField.configureWith(viewModel.data[indexPath.row])
            textCell.textInputField.textField.delegate = self
            
            return textCell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section == SendProtocolSection.pictures.rawValue else {
            return 0.0
        }
        
        return TibTheme().photoButtonsTableFooterSectionHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == SendProtocolSection.pictures.rawValue else {
            return nil
        }
        
        return addPhotoButtonsAsSectionFooterView()
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
