//
//  RegistrationViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 23.04.21.
//

import UIKit

final class RegistrationViewController: BaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var viewModel = RegistrationViewModel()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func applyTheme() {
        super.applyTheme()
        
        let theme = TibTheme()
        tableView.backgroundColor = theme.backgroundColor
    }
    
    // MARK: - Private methods
    
    @objc private func tryRegistration(_ sender: UIButton) {
        print("tryRegistration is not implemented")
    }
    
    private func tableViewHeaderView() -> UIView {
        let theme = TibTheme()
        let bounds = UIScreen.main.bounds
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: bounds.size.width, height: bounds.size.height * 0.1))
        label.textColor = theme.textFieldColor
        label.font = .boldFont(size: 18.0)
        label.text = LocalizedStrings.Registration.title
        label.textAlignment = .center
        
        return label
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
    
    private func setupTableView() {
        tableView.registerCell(TextCell.self)
        tableView.registerCell(PickerCell.self)
        tableView.registerCell(CheckboxCell.self)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.separatorColor = .none
        tableView.rowHeight = 86.0
        tableView.tableHeaderView = tableViewHeaderView()
        tableView.tableFooterView = registrationButtonView()
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
        
        if model.isTextField {
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

// MARK: - UITableViewDelegate

extension RegistrationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if viewModel.data[indexPath.row].isPickerField {
            showSearchController(for: indexPath)
        }
    }
    
    // MARK: - Private methods (UITableViewDelegate)
    
    private func showSearchController(for indexPath: IndexPath) {
        let controller = SearchViewController.init(nibName: SearchViewController.nibName, bundle: nil)
        controller.delegate = self
        controller.parentCellIndexPath = indexPath
        controller.selectedItem = viewModel.data[indexPath.row].data as? SearchItem
        
        let navController = UINavigationController(rootViewController: controller)
        self.present(navController, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateValueForTextField(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateValueForTextField(textField)
        
        return true
    }
    
    // MARK: - Private methods (UITextFieldDelegate)
    
    private func cellForTextField(_ textField: UITextField) -> UITableViewCell? {
        return tableView.visibleCells.filter { cell in
            if let textCell = cell as? TextCell {
                return textCell.textInputField.textField == textField
            } else {
                return false
            }
        }.first
    }
    
    private func updateValueForTextField(_ textField: UITextField) {
        textField.resignFirstResponder()
        
        if let cell = cellForTextField(textField), let indexPath = tableView.indexPath(for: cell) {
            viewModel.updateValue(textField.text as AnyObject, at: indexPath)
        }
    }
}

// MARK: - SearchViewControllerDelegate

extension RegistrationViewController: SearchViewControllerDelegate {
    
    func didFinishSearching(value: SearchItem?, sender: SearchViewController) {
        if let indexPath = sender.parentCellIndexPath {
            viewModel.updateValue(value as AnyObject, at: indexPath)
        }
        
        tableView.reloadData()
        sender.dismiss(animated: true, completion: nil)
    }
}

// MARK: - CheckbboxCellDelegate

extension RegistrationViewController: CheckboxCellDelegate {
    
    func didChangeCheckboxState(state: CheckboxState, sender: CheckboxCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            viewModel.updateValue((state == .checked) as AnyObject, at: indexPath)
        }
    }
}
