//
//  ProfileViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 4/13/21.
//  
//

import UIKit
import Combine

final class ProfileViewController: BaseTableViewController {
    
    private let viewModel = ProfileViewModel()
    private var saveSubscription: AnyCancellable?
    private var deleteSubscription: AnyCancellable?
    
    weak var coordinator: ContentContainerCoordinator?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObservers()
        viewModel.start()
        
        baseViewModel = viewModel
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        parent?.parent?.navigationItem.rightBarButtonItem = nil
    }
    
    override func setupTableView() {
        super.setupTableView()
        tableView.registerCell(TextCell.self)
        tableView.registerCell(PickerCell.self)
        tableView.registerCell(CheckboxCell.self)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.setHeaderView(text: LocalizedStrings.Menu.profile.uppercased())
        tableView.tableFooterView = saveButtonView()
    }
    
    override func updateTextInputFieldValue(_ value: AnyObject?, at indexPath: IndexPath) {
        viewModel.updateFieldValue(value, at: indexPath)
    }
    
    // MARK: - Private methods
    
    @objc private func handleSaveButton(_ sender: UIButton) {
        if let errorMessage = viewModel.validator.validateProfile(fields: viewModel.data).first {
            view.showMessage(errorMessage)
        } else {
            viewModel.saveProfile()
        }
    }
    
    @objc private func handleDeleteButton(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(
            title: nil,
            message: LocalizedStrings.Profile.ConfirmDelete.message,
            preferredStyle: .alert
        )
        
        let deleteAction = UIAlertAction(
            title: LocalizedStrings.Profile.ConfirmDelete.deleteAction,
            style: .destructive,
            handler: { [weak self] _ in
                self?.viewModel.deleteProfile()
            })
        
        let cancelAction = UIAlertAction(title: LocalizedStrings.Profile.ConfirmDelete.cancelAction, style: .cancel)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func saveButtonView() -> UIView {
        let theme = TibTheme()
        let bounds = UIScreen.main.bounds
        let container = UIView(frame: CGRect(x: 0.0, y: 0.0, width: bounds.size.width, height: bounds.size.height * 0.1))
        container.backgroundColor = theme.backgroundColor
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button.configureSolidButton(title: LocalizedStrings.Buttons.save.uppercased(), theme: theme)
        button.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        container.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: bounds.size.width * 0.5),
            button.heightAnchor.constraint(equalToConstant: theme.defaultButtonHeight),
            button.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])
        
        return container
    }
    
    private func configureDeleteButton() {
        let image = UIImage(named: SharedAssetsConfig.delete)?.withRenderingMode(.alwaysTemplate)
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleDeleteButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 24.0),
            button.heightAnchor.constraint(equalToConstant: 24.0)
        ])
        
        let deleteButton = UIBarButtonItem(customView: button)
        // note: - parent?.parent? (ContentContainerViewController.contentViewController)
        parent?.parent?.navigationItem.setRightBarButton(deleteButton, animated: true)
    }
    
    private func setupViews() {
        setupTableView()
        configureDeleteButton()
    }
    
    private func observeReloadDataPublisher() {
        reloadDataSubscription = viewModel
            .reloadDataPublisher
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [unowned self] error in
                    tableView.reloadData()
                    
                    if let error = error {
                        print("reload data failed \(error)")
                        view.showMessage(error.localizedDescription)
                    } else {
                        viewModel.loadingPublisher.send(false)
                    }
                })
    }
    
    @objc private func navigateToHome() {
        coordinator?.start()
    }
    
    private func observeSavePublisher() {
        saveSubscription = viewModel
            .savePublisher
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [unowned self] error in
                    tableView.reloadData()
                    viewModel.loadingPublisher.send(false)
                    
                    if let error = error {
                        print("reload data failed \(error)")
                        
                        switch error {
                        case .requestFailed(let responseErrors):
                            view.showMessage(responseErrors.firstError ?? LocalizedStrings.Errors.defaultError)
                        default:
                            view.showMessage(LocalizedStrings.Errors.defaultError)
                        }
                    } else {
                        view.showMessage(LocalizedStrings.Profile.saved)
                        perform(#selector(navigateToHome), with: nil, afterDelay: 1)
                    }
                })
    }
    
    @objc private func forceLogout() {
        NotificationCenter.default.post(name: NSNotification.Name.forceLogout, object: nil)
    }
    
    private func observeDeletePublisher() {
        deleteSubscription = viewModel
            .deletePublisher
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [unowned self] error in
                    tableView.reloadData()
                    viewModel.loadingPublisher.send(false)
                    
                    if let error = error {
                        switch error {
                        case .requestFailed(let responseErrors):
                            view.showMessage(responseErrors.firstError ?? LocalizedStrings.Errors.defaultError)
                        default:
                            view.showMessage(LocalizedStrings.Errors.defaultError)
                        }
                    } else {
                        view.showMessage(LocalizedStrings.Profile.deleted)
                        perform(#selector(forceLogout), with: nil, afterDelay: 1)
                    }
                })
    }
    
    private func observeLoadingPublisher() {
        loadingSubscription = viewModel.loadingPublisher.sink(receiveValue: { [unowned self] isLoading in
            isLoading ? view.showLoading() : view.hideLoading()
        })
    }
    
    private func addObservers() {
        observeReloadDataPublisher()
        observeSavePublisher()
        observeDeletePublisher()
        observeLoadingPublisher()
    }
}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    
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
        
        if model.isTextField {
            let reusableCell = tableView.dequeueReusableCell(withIdentifier: TextCell.cellIdentifier, for: indexPath)
            guard let textCell = reusableCell as? TextCell  else {
                return UITableViewCell()
            }

            textCell.textInputField.configureWith(model)
            textCell.textInputField.textField.delegate = self
            
            if model.type == .email {
                textCell.markAsDisabled()
            }
            
            cell = textCell
        } else if model.isPickerField {
            let reusableCell = tableView.dequeueReusableCell(withIdentifier: PickerCell.cellIdentifier, for: indexPath)
            guard let pickerCell = reusableCell as? PickerCell else {
                return UITableViewCell()
            }

            pickerCell.configureWith(model)
            pickerCell.markAsDisabled()
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

// MARK: - UITableViewDelegate

extension ProfileViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - CheckbboxCellDelegate

extension ProfileViewController: CheckboxCellDelegate {
    
    func didChangeCheckboxState(state: CheckboxState, sender: CheckboxCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            viewModel.updateFieldValue(state as AnyObject, at: indexPath)
        }
    }
}
