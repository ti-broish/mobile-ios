//
//  BaseTableViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 16.06.21.
//

import UIKit

class BaseTableViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var baseViewModel = BaseViewModel()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
    }
    
    override func applyTheme() {
        super.applyTheme()
        
        let theme = TibTheme()
        tableView.backgroundColor = theme.backgroundColor
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.separatorColor = .none
        tableView.rowHeight = 86.0
        tableView.tableFooterView = UIView()
    }
    
    func updateTextInputFieldValue(_ value: AnyObject?, at indexPath: IndexPath) {
        assertionFailure("updateTextInputFieldValue:at not implemented")
    }
    
    @objc func handleSendButton(_ sender: UIButton) {
        assertionFailure("handleSendButton not implemented")
    }
    
    func sendButtonTableFooterView() -> UIView {
        let theme = TibTheme()
        let bounds = UIScreen.main.bounds
        let container = UIView(frame: CGRect(x: 0.0, y: 0.0, width: bounds.size.width, height: 100.0))
        container.backgroundColor = theme.backgroundColor
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button.configureSolidButton(title: LocalizedStrings.Buttons.send, theme: theme)
        button.addTarget(self, action: #selector(handleSendButton), for: .touchUpInside)
        container.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: bounds.size.width * 0.5),
            button.heightAnchor.constraint(equalToConstant: theme.defaultButtonHeight),
            button.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])
        
        return container
    }
    
    func shouldShowSearchController(for indexPath: IndexPath) -> Bool {
        guard let fieldType = baseViewModel.data[indexPath.row].dataType as? SendFieldType else {
            return false
        }
        
        forceResignFirstResponder()
        
        switch fieldType {
        case .municipality:
            if let _ = baseViewModel.dataForSendField(type: .electionRegion) {
                return true
            } else {
                view.showMessage(LocalizedStrings.SendInputField.electionRegionNotSet)
                return false
            }
        case .town:
            if let _ = baseViewModel.dataForSendField(type: baseViewModel.isAbroad ? .countries : .municipality) {
                return true
            } else {
                if baseViewModel.isAbroad {
                    view.showMessage(LocalizedStrings.SendInputField.countryNotSet)
                } else {
                    view.showMessage(LocalizedStrings.SendInputField.municipalityNotSet)
                }
                return false
            }
        case .section:
            if let town = baseViewModel.dataForSendField(type: .town) as? Town {
                let cityRegionsCount = town.cityRegions?.count ?? 0
                
                if  cityRegionsCount > 0 {
                    if let _ = baseViewModel.dataForSendField(type: .cityRegion) {
                        return true
                    } else {
                        view.showMessage(LocalizedStrings.SendInputField.cityRegionNotSet)
                        return false
                    }
                } else {
                    return true
                }
            } else {
                view.showMessage(LocalizedStrings.SendInputField.townNotSet)
                return false
            }
        default:
            return true
        }
    }
    
    func loadData(searchController: SearchViewController) {
        switch searchController.viewModel.searchType {
        case .municipalities:
            if let electionRegion = baseViewModel.dataForSendField(type: .electionRegion) as? ElectionRegion {
                searchController.viewModel.loadMunicipalities(electionRegion.municipalities)
            }
        case .towns:
            let electionRegion = baseViewModel.dataForSendField(type: .electionRegion) as? ElectionRegion
            let country = baseViewModel.dataForSendField(type: .countries) as? Country ?? Country.defaultCountry
            let municipality = baseViewModel.dataForSendField(type: .municipality) as? Municipality
            
            searchController.viewModel.getTowns(
                country: country,
                electionRegion: electionRegion,
                municipality: municipality
            )
        case .cityRegions:
            if let town = baseViewModel.dataForSendField(type: .town) as? Town,
               let cityRegions = town.cityRegions
            {
                searchController.viewModel.loadCityRegions(cityRegions)
            }
        case .sections:
            guard let town = baseViewModel.dataForSendField(type: .town) as? Town else {
                return
            }
            
            let cityRegion = baseViewModel.dataForSendField(type: .cityRegion) as? CityRegion
            
            searchController.viewModel.getSections(town: town, cityRegion: cityRegion)
        default:
            break
        }
    }
    
    func showSearchController(for indexPath: IndexPath) {
        let viewController = SearchViewController.init(nibName: SearchViewController.nibName, bundle: nil)
        let searchType = baseViewModel.getSearchType(for: indexPath)
        viewController.viewModel.setSearchType(searchType, isAbroad: baseViewModel.isAbroad)
        viewController.delegate = self
        viewController.parentCellIndexPath = indexPath
        viewController.selectedItem = baseViewModel.data[indexPath.row].data as? SearchItem
        loadData(searchController: viewController)
        
        let navController = UINavigationController(rootViewController: viewController)
        self.present(navController, animated: true)
    }
    
    func forceResignFirstResponder() {
        for visibleCell in tableView.visibleCells {
            if let textCell = visibleCell as? TextCell {
                textCell.textInputField.textField.resignFirstResponder()
                break
            } else if let descriptionCell = visibleCell as? DescriptionCell {
                descriptionCell.textView.resignFirstResponder()
                break
            }
        }
    }

    // MARK: - Private methods
    
    private func addObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func getFirstResponderPosition() -> CGPoint? {
        let cell = tableView.visibleCells.first(where: { visibleCell in
            if let textCell = visibleCell as? TextCell {
                return textCell.textInputField.textField.isFirstResponder
            } else if let descriptionCell = visibleCell as? DescriptionCell {
                return descriptionCell.textView.isFirstResponder
            } else {
                return false
            }
        })
        
        return cell?.frame.origin ?? nil
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if tableView.frame.origin.y == 0 {
                if let frame = getFirstResponderPosition(), frame.y > (tableView.frame.size.height / 2.0) {
                    tableView.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if tableView.frame.origin.y != 0 {
            tableView.frame.origin.y = 0
        }
    }
}

// MARK: - UITableViewDelegate

extension BaseTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard
            indexPath.section == SendSectionType.data.rawValue,
            indexPath.row < baseViewModel.data.count
        else {
            return
        }
        
        if baseViewModel.data[indexPath.row].isPickerField, shouldShowSearchController(for: indexPath) {
            showSearchController(for: indexPath)
        }
    }
}

// MARK: - UITextFieldDelegate

extension BaseTableViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateValueForTextField(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateValueForTextField(textField)
        
        return true
    }
    
    // MARK: - Private methods (UITextFieldDelegate)
    
    private func cellFor(textField: UITextField) -> UITableViewCell? {
        return tableView.visibleCells.filter { cell in
            if let textCell = cell as? TextCell {
                return textCell.textInputField.textField == textField
            } else if let phoneCell = cell as? RegistrationPhoneCell {
                return phoneCell.numberTextField == textField
            } else {
                return false
            }
        }.first
    }
    
    private func updateValueForTextField(_ textField: UITextField) {
        textField.resignFirstResponder()
        
        if let cell = cellFor(textField: textField),
           let indexPath = tableView.indexPath(for: cell)
        {
            updateTextInputFieldValue(textField.text as AnyObject, at: indexPath)
        }
    }
}

// MARK: - SearchViewControllerDelegate

extension BaseTableViewController: SearchViewControllerDelegate {
    
    func didFinishSearching(value: SearchItem?, sender: SearchViewController) {
        if value?.type == .phoneCode {
            if let viewModel = baseViewModel as? RegistrationViewModel {
                viewModel.countryPhoneCode = value?.data as? CountryPhoneCode
            }
        } else if let indexPath = sender.parentCellIndexPath {
            baseViewModel.updateFieldValue(value as AnyObject, at: indexPath)
        }
        
        tableView.reloadData()
        sender.dismiss(animated: true, completion: nil)
    }
}

// MARK: - CountryCellDelegate

extension BaseTableViewController: CountryCellDelegate {
    
    func didChangeCountryType(_ type: CountryType, sender: CountryCell) {
        baseViewModel.isAbroad = type == .abroad
        
        tableView.reloadData()
    }
}
