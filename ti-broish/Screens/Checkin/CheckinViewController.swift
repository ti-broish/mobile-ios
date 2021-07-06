//
//  CheckinViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 6.07.21.
//

import UIKit

final class CheckinViewController: SendViewController {
    
    private let viewModel = CheckinViewModel()
    
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
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.setHeaderView(text: LocalizedStrings.Menu.checkin)
        tableView.tableFooterView = sendButtonTableFooterView()
    }
    
    override func updateTextInputFieldValue(_ value: AnyObject?, at indexPath: IndexPath) {
        viewModel.updateFieldValue(value, at: indexPath)
    }
    
    override func updateSelectedImages(_ images: [UIImage]) {
        viewModel.setImages(images)
        tableView.reloadData()
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
            viewModel.sendCheckin()
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

                    if error != nil {
                        switch error {
                        case .requestFailed(let responseError) :
                            view.showMessage(responseError.message.first ?? LocalizedStrings.Errors.defaultError)
                        default:
                            break
                        }
                    } else {
                        view.showMessage(LocalizedStrings.Checkin.sent)
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

extension CheckinViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SendSectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = SendSectionType(rawValue: section)
        
        switch section {
        case .data:
            return viewModel.data.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = SendSectionType(rawValue: indexPath.section)
        
        switch section {
        case .data:
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
        default:
            return UITableViewCell()
        }
    }
}
