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
    private var startStreamSubscription: AnyCancellable?
        
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObservers()
        viewModel.start()
        
        baseViewModel = viewModel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
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
        tableView.setHeaderView(text: LocalizedStrings.Menu.live)
        tableView.tableFooterView = sendButtonTableFooterView()
    }
    
    override func handleSendButton(_ sender: UIButton) {
        let dataFields: [SendFieldType] = viewModel.isAbroad
            ? [.countries, .town, .section]
            : [.electionRegion, .municipality, .town, .section]
        
        var message: String? = nil
        
        for field in dataFields {
            if let errorMessage = viewModel.errorMessageForField(type: field) {
                message = errorMessage
                break
            }
        }
        
        if let message = message {
            view.showMessage(message)
        } else {
            if let section = viewModel.dataForSendField(type: .section) as? Section {
                viewModel.tryStartStream(section: section)
            } else {
                view.showMessage(LocalizedStrings.Errors.invalidSection)
            }
        }
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
                receiveCompletion: { _ in },
                receiveValue: { [unowned self] error in
                    tableView.reloadData()
                    view.hideLoading()
                    
                    switch error {
                    case .requestFailed(let responseError) :
                        view.showMessage(responseError.message.first ?? LocalizedStrings.Errors.defaultError)
                    default:
                        break
                    }
                })
    }
    
    private func observeLoadingPublisher() {
        loadingSubscription = viewModel.loadingPublisher.sink(receiveValue: { [unowned self] isLoading in
            isLoading ? view.showLoading() : view.hideLoading()
        })
    }
    
    private func showStartStream(stream: StreamResponse) {
        let controller = LaunchStreamController.instantiate()
        controller.streamInfo = UserStream(streamUrl: stream.streamUrl, viewUrl: stream.viewUrl)
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func observeStartStreamPublisher() {
        startStreamSubscription = viewModel
            .startStreamPublisher
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [unowned self] stream in
                    showStartStream(stream: stream)
                    view.hideLoading()
                })
    }
    
    private func addObservers() {
        observeSendPublisher()
        observeLoadingPublisher()
        observeStartStreamPublisher()
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
