//
//  BaseTableViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 16.06.21.
//

import UIKit
import Photos

class BaseTableViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var baseViewModel = BaseViewModel()
    
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
    
    @objc func handlePhotoGalleryButton(_ sender: UIButton) {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        // User has not yet made a choice with regards to this application
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        self?.showPhotosPickerViewController()
                    }
                }
            }
        case .authorized:
            showPhotosPickerViewController()
        default:
            showSettings()
        }
    }
    
    @objc func handleCameraButton(_ sender: UIButton) {
        let controller = UIImagePickerController()
        controller.sourceType = .camera
        controller.allowsEditing = true
        controller.delegate = self
        present(controller, animated: true)
    }
    
    func updateSelectedImages(_ images: [UIImage]) {
        assertionFailure("updateSelectedImages not implemented")
    }
    
    func shouldShowSearchController(for indexPath: IndexPath) -> Bool {
        guard let fieldType = baseViewModel.data[indexPath.row].dataType as? SendFieldType else {
            return false
        }
        
        switch fieldType {
        case .municipality:
            if let _ = baseViewModel.dataForField(type: .electionRegion) {
                return true
            } else {
                view.showMessage(LocalizedStrings.SendInputField.electionRegionNotSet)
                return false
            }
        case .town:
            if let _ = baseViewModel.dataForField(type: baseViewModel.isAbroad ? .countries : .municipality) {
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
            if let town = baseViewModel.dataForField(type: .town) as? Town {
                let cityRegionsCount = town.cityRegions?.count ?? 0
                
                if  cityRegionsCount > 0 {
                    if let _ = baseViewModel.dataForField(type: .cityRegion) {
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
            if let electionRegion = baseViewModel.dataForField(type: .electionRegion) as? ElectionRegion {
                searchController.viewModel.loadMunicipalities(electionRegion.municipalities)
            }
        case .towns:
            let electionRegion = baseViewModel.dataForField(type: .electionRegion) as? ElectionRegion
            let country = baseViewModel.dataForField(type: .countries) as? Country ?? Country.defaultCountry
            let municipality = baseViewModel.dataForField(type: .municipality) as? Municipality
            
            searchController.viewModel.getTowns(
                country: country,
                electionRegion: electionRegion,
                municipality: municipality
            )
        case .cityRegions:
            if let town = baseViewModel.dataForField(type: .town) as? Town,
               let cityRegions = town.cityRegions
            {
                searchController.viewModel.loadCityRegions(cityRegions)
            }
        case .sections:
            guard let town = baseViewModel.dataForField(type: .town) as? Town else {
                return
            }
            
            let cityRegion = baseViewModel.dataForField(type: .cityRegion) as? CityRegion
            
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
    
    // MARK: - Private methods
    
    private func showPhotosPickerViewController() {
        let viewController = PhotosPickerViewController(nibName: PhotosPickerViewController.nibName, bundle: nil)
        viewController.delegate = self
        
        present(viewController, animated: true)
    }
    
    private func showSettings() {
        let alertController = UIAlertController(
            title: LocalizedStrings.Photos.Settings.title,
            message: LocalizedStrings.Photos.Settings.message,
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: LocalizedStrings.Buttons.cancel, style: .default))
        alertController.addAction(UIAlertAction(title: LocalizedStrings.Photos.Settings.settings, style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        
        present(alertController, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension BaseTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if baseViewModel.data[indexPath.row].isPickerField {
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
            } else {
                return false
            }
        }.first
    }
    
    func updateValueForTextField(_ textField: UITextField) {
        textField.resignFirstResponder()
        
        if let cell = cellFor(textField: textField),
           let indexPath = tableView.indexPath(for: cell)
        {
            updateTextInputFieldValue(textField.text as AnyObject, at: indexPath)
        }
    }
}

// MARK: - PhotosPickerDelegate

extension BaseTableViewController: PhotosPickerDelegate {
    
    func didSelectPhotos(_ photos: [UIImage], sender: PhotosPickerViewController) {
        print("didSelectPhotos: \(photos)")
        updateSelectedImages(photos)
        sender.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension BaseTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        updateSelectedImages([image])
    }
}

// MARK: - SearchViewControllerDelegate

extension BaseTableViewController: SearchViewControllerDelegate {
    
    func didFinishSearching(value: SearchItem?, sender: SearchViewController) {
        if let indexPath = sender.parentCellIndexPath {
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

