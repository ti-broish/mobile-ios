//
//  RegistrationViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 23.04.21.
//

import UIKit
import Combine

final class RegistrationViewController: BaseTableViewController {
    
    private var viewModel = RegistrationViewModel()
    private var registrationSubscription: AnyCancellable?
    private var registrationFailedSubscription: AnyCancellable?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        addObservers()
        viewModel.start()
        
        baseViewModel = viewModel
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func setupTableView() {
        super.setupTableView()
        tableView.registerCell(TextCell.self)
        tableView.registerCell(RegistrationPhoneCell.self)
        tableView.registerCell(PickerCell.self)
        tableView.registerCell(CheckboxCell.self)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.setHeaderView(text: LocalizedStrings.Registration.title)
        tableView.tableFooterView = registrationButtonView()
    }
    
    override func updateTextInputFieldValue(_ value: AnyObject?, at indexPath: IndexPath) {
        viewModel.updateFieldValue(value, at: indexPath)
    }
    
    // MARK: - Private methods
    
    private func observeRegistrationPublisher() {
        registrationSubscription = viewModel
            .registrationPublisher
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [unowned self] message in
                    LocalStorage.User().reset()
                    tableView.reloadData()
                    view.hideLoading()
                    
                    NotificationCenter.default.post(name: NSNotification.Name.emailVerification, object: message)
                    navigationController?.popToRootViewController(animated: true)
                })
    }
    
    private func observeRegistrationFailedPublisher() {
        registrationFailedSubscription = viewModel
            .registrationPublisher
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [unowned self] message in
                    LocalStorage.User().reset()
                    tableView.reloadData()
                    
                    view.hideLoading()
                    view.showMessage(message)
                })
    }
    
    private func observeLoadingPublisher() {
        loadingSubscription = viewModel.loadingPublisher.sink(receiveValue: { [unowned self] isLoading in
            isLoading ? view.showLoading() : view.hideLoading()
        })
    }
    
    private func addObservers() {
        observeRegistrationPublisher()
        observeRegistrationFailedPublisher()
        observeLoadingPublisher()
    }
    
    @objc private func tryRegistration(_ sender: UIButton) {
        if let errorMessage = viewModel.validator.validateRegistration(fields: viewModel.data).first {
            view.showMessage(errorMessage)
        } else {
            viewModel.register()
        }
    }
    
    private func registrationButtonView() -> UIView {
        let theme = TibTheme()
        let bounds = UIScreen.main.bounds
        let container = UIView(frame: CGRect(x: 0.0, y: 0.0, width: bounds.size.width, height: bounds.size.height * 0.2))
        container.backgroundColor = theme.backgroundColor
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button.configureSolidButton(title: LocalizedStrings.Registration.registerButton, theme: theme)
        button.addTarget(self, action: #selector(tryRegistration), for: .touchUpInside)
        container.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: bounds.size.width * 0.5),
            button.heightAnchor.constraint(equalToConstant: theme.defaultButtonHeight),
            button.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])
        
        return container
    }
    
    @objc private func handleCountryCodeButton(_ sender: UIButton) {
        guard let indexPath = viewModel.phoneIndexPath else {
            return
        }
        
        let viewController = SearchViewController.init(nibName: SearchViewController.nibName, bundle: nil)
        viewController.viewModel.setSearchType(.countryPhoneCodes, isAbroad: false)
        viewController.delegate = self
        viewController.parentCellIndexPath = indexPath
        viewController.selectedItem = viewModel.countryPhoneCodeSearchItem
        loadData(searchController: viewController)
        
        let navController = UINavigationController(rootViewController: viewController)
        self.present(navController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension RegistrationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.data[indexPath.row]
        let cell: UITableViewCell
        
        if model.type == .phone {
            let reusableCell = tableView.dequeueReusableCell(
                withIdentifier: RegistrationPhoneCell.cellIdentifier,
                for: indexPath
            )
            
            guard let phoneCell = reusableCell as? RegistrationPhoneCell  else {
                return UITableViewCell()
            }

            phoneCell.configureWith(
                model,
                countryPhoneCode: viewModel.countryPhoneCode ?? CountryPhoneCode.defaultCountryPhoneCode
            )
            
            phoneCell.codeButton.addTarget(self, action: #selector(handleCountryCodeButton), for: .touchUpInside)
            phoneCell.numberTextField.delegate = self
            cell = phoneCell
        } else if model.isTextField {
            let reusableCell = tableView.dequeueReusableCell(withIdentifier: TextCell.cellIdentifier, for: indexPath)
            guard let textCell = reusableCell as? TextCell  else {
                return UITableViewCell()
            }

            textCell.textInputField.configureWith(model)
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
            let reusableCell = tableView.dequeueReusableCell(withIdentifier: CheckboxCell.cellIdentifier, for: indexPath)
            guard let checkboxCell = reusableCell as? CheckboxCell else {
                return UITableViewCell()
            }

            checkboxCell.configureWith(model)
            checkboxCell.delegate = self
            cell = checkboxCell
        } else {
            cell = UITableViewCell()
        }
        
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        return cell
    }
}

// MARK: - CheckbboxCellDelegate

extension RegistrationViewController: CheckboxCellDelegate {
    
    func didChangeCheckboxState(state: CheckboxState, sender: CheckboxCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            viewModel.updateFieldValue(state as AnyObject, at: indexPath)
        }
    }
}
