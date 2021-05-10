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
    
    private func setupTableView() {
        tableView.registerCell(RegistrationTextCell.self)
        tableView.registerCell(PickerCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.separatorColor = .none
        tableView.rowHeight = 86.0
        tableView.tableFooterView = UIView()
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
        return viewModel.inputFieldsConfigs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.inputFieldsConfigs[indexPath.row]
        let cell: UITableViewCell
        
        if model.isTextInputField {
            let textCell = tableView.dequeueReusableCell(
                withIdentifier: RegistrationTextCell.cellIdentifier,
                for: indexPath
            )
            
            guard let textCell = textCell as? RegistrationTextCell  else {
                return UITableViewCell()
            }
            
            textCell.textInputField.configureWith(model)
            textCell.textInputField.textField.delegate = self
            cell = textCell
        } else if model.isPickerInputField {
            let pickerCell = tableView.dequeueReusableCell(withIdentifier: PickerCell.cellIdentifier, for: indexPath)
            guard let pickerCell = pickerCell as? PickerCell else {
                return UITableViewCell()
            }
            
            pickerCell.configureWith(model)
            cell = pickerCell
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
    }
}

// MARK: - UITextFieldDelegate

extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
