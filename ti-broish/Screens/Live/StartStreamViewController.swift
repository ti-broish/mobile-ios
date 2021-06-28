//
//  StartStreamViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 28.06.21.
//

import UIKit
import Combine

final class StartStreamViewController: BaseTableViewController {
    
    private let viewModel = StartStreamViewModel()
    private var sendSubscription: AnyCancellable?
        
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObservers()
        viewModel.start()
        
        baseViewModel = viewModel
    }
    
    override func setupTableView() {
        super.setupTableView()
        tableView.registerCell(CountryCell.self)
        tableView.registerCell(TextCell.self)
        tableView.registerCell(PickerCell.self)
        tableView.registerCell(UploadImageCell.self)
        tableView.registerCell(PhotoButtonsCell.self)
        tableView.registerCell(DescriptionCell.self)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.setHeaderView(text: LocalizedStrings.Menu.sendViolation)
        tableView.tableFooterView = sendButtonTableFooterView()
    }
    
    override func handleSendButton(_ sender: UIButton) {
        
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        navigationItem.configureTitleView()
        setupTableView()
    }
    
    private func observeSendPublisher() {
        sendSubscription = viewModel
            .sendPublisher
            .sink(
                receiveCompletion: { [unowned self] _ in
                    tableView.reloadData()
                    view.hideLoading()
                },
                receiveValue: { [unowned self] error in
                    tableView.reloadData()
                    view.hideLoading()

                    if error != nil {
                        switch error {
                        case .requestFailed(let responseError) :
                            view.showMessage(responseError.message.first ?? LocalizedStrings.Errors.defaultError)
                        default:
                            break
                        }
                    } else {
                        view.showMessage(LocalizedStrings.Violations.sent)
                    }
                })
    }
    
    private func observeLoadingPublisher() {
        loadingSubscription = viewModel.loadingPublisher.sink(receiveValue: { [unowned self] isLoading in
            isLoading ? view.showLoading() : view.hideLoading()
        })
    }
    
    private func addObservers() {
        observeSendPublisher()
        observeLoadingPublisher()
    }
}

// MARK: - UITableViewDataSource

extension StartStreamViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.data[indexPath.row]
        let cell: UITableViewCell
        
        if model.isTextField {
            let reusableCell = tableView.dequeueReusableCell(withIdentifier: TextCell.cellIdentifier, for: indexPath)
            guard let textCell = reusableCell as? TextCell  else {
                return UITableViewCell()
            }
            
            textCell.configureWith(model)
            textCell.textInputField.textField.delegate = self
            
            cell = textCell
        } else if model.isPickerField {
            let reusableCell = tableView.dequeueReusableCell(withIdentifier: PickerCell.cellIdentifier, for: indexPath)
            guard let pickerCell = reusableCell as? PickerCell else {
                return UITableViewCell()
            }
            
            pickerCell.configureWith(model)
            
            cell = pickerCell
        } else if model.isCheckboxField {
            let reusableCell = tableView.dequeueReusableCell(withIdentifier: CountryCell.cellIdentifier, for: indexPath)
            guard let countryCell = reusableCell as? CountryCell else {
                return UITableViewCell()
            }
            
            countryCell.delegate = self
            
            cell = countryCell
        } else {
            cell = UITableViewCell()
        }
        
        return cell
    }
}
