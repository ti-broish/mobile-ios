//
//  SendViolationViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 23.04.21.
//

import UIKit

final class SendViolationViewController: BaseTableViewController {
    
    private let viewModel = SendViolationViewModel()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.start()
    }
    
    override func setupTableView() {
        super.setupTableView()
        tableView.registerCell(TextCell.self)
        tableView.registerCell(PickerCell.self)
        tableView.registerCell(UploadImageCell.self)
        tableView.registerCell(PhotoButtonsCell.self)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.setHeaderView(text: LocalizedStrings.Menu.sendViolation)
        tableView.tableFooterView = sendButtonTableFooterView()
    }
    
    override func updateTextInputFieldValue(_ value: AnyObject?, at indexPath: IndexPath) {
        viewModel.updateFieldValue(value, at: indexPath)
    }
    
    override func updateSelectedImages(_ images: [UIImage]) {
        viewModel.setImages(images)
        tableView.reloadData()
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        navigationItem.configureTitleView()
        setupTableView()
    }
}

// MARK: - UITableViewDataSource

extension SendViolationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SendSectionFieldType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = SendSectionFieldType(rawValue: section)
        
        switch section {
        case .data:
            return viewModel.data.count
        case .images:
            return viewModel.images.count
        case .buttons:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = SendSectionFieldType(rawValue: indexPath.section)
        
        switch section {
        case .data:
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
            } else {
                cell = UITableViewCell()
            }
            
            return cell
        case .images:
            let reusableCell = tableView.dequeueReusableCell(
                withIdentifier: UploadImageCell.cellIdentifier,
                for: indexPath
            )
            
            guard let uploadImageCell = reusableCell as? UploadImageCell else {
                return UITableViewCell()
            }
            
            uploadImageCell.configure(image: viewModel.images[indexPath.row], indexPath: indexPath)
            uploadImageCell.deleteButton.addTarget(self, action: #selector(handleDeleteImage), for: .touchUpInside)
            
            return uploadImageCell
        case .buttons:
            let reusableCell = tableView.dequeueReusableCell(
                withIdentifier: PhotoButtonsCell.cellIdentifier,
                for: indexPath
            )
            
            guard let photoButtonsCell = reusableCell as? PhotoButtonsCell else {
                return UITableViewCell()
            }
            
            photoButtonsCell.galleryButton.addTarget(self, action: #selector(handlePhotoGalleryButton), for: .touchUpInside)
            photoButtonsCell.cameraButton.addTarget(self, action: #selector(handleCameraButton), for: .touchUpInside)
            
            return photoButtonsCell
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - Private methods
    
    @objc private func handleDeleteImage(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: SendSectionFieldType.images.rawValue)
        
        guard let _ = tableView.cellForRow(at: indexPath) as? UploadImageCell else {
            return
        }
        
        viewModel.removeImage(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - UITableViewDelegate

extension SendViolationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if viewModel.data[indexPath.row].isPickerField {
            showSearchController(for: indexPath)
        }
    }
    
    // MARK: - Private methods (UITableViewDelegate)
    
    private func hasCityRegions() -> Bool {
        guard
            let item = getInputFieldConfigData(type: .town) as? SearchItem,
            let town = item.data as? Town
        else {
            return false
        }
        
        return town.cityRegions.count > 0
    }
    
    private func getSearchType(for indexPath: IndexPath) -> SearchType? {
        let model = viewModel.data[indexPath.row]
        
        guard let fieldType = model.dataType as? SendViolationFieldType else {
            return nil
        }
        
        switch fieldType {
        case .electionRegion:
            return .electionRegions
        case .municipality:
            return .municipalities
        case .town:
            return .towns
        case .cityRegion:
            return .cityRegions
        case .section:
            return .sections
        }
    }
    
    private func getInputFieldConfigData(type: SendViolationFieldType) -> AnyObject? {
        let inputFieldConfig = viewModel.data.first(where: { inputFieldConfig in
            if let fieldType = inputFieldConfig.dataType as? SendViolationFieldType {
                return fieldType == type
            } else {
                return false
            }
        })
        
        return inputFieldConfig?.data
    }
    
    private func showSearchController(for indexPath: IndexPath) {
        // TODO: - is abroad?
        let viewController = SearchViewController.init(nibName: SearchViewController.nibName, bundle: nil)
        let searchType = getSearchType(for: indexPath)
        viewController.viewModel.setSearchType(searchType, isAbroad: false)
        viewController.delegate = self
        viewController.parentCellIndexPath = indexPath
        viewController.selectedItem = viewModel.data[indexPath.row].data as? SearchItem
        
        switch searchType {
        case .municipalities:
            if let searchItem = getInputFieldConfigData(type: .electionRegion) as? SearchItem,
               let electionRegion = searchItem.data as? ElectionRegion
            {
                viewController.viewModel.loadMunicipalities(electionRegion.municipalities)
            }
        case .towns:
            let electionRegionItem = getInputFieldConfigData(type: .electionRegion) as? SearchItem
            let electionRegion = electionRegionItem?.data as? ElectionRegion
            // TODO: - country
            let country = Country(code: "00", name: "България", isAbroad: false)
            let municipalityItem = getInputFieldConfigData(type: .municipality) as? SearchItem
            let municipality = municipalityItem?.data as? Municipality
            
            viewController.viewModel.getTowns(
                country: country,
                electionRegion: electionRegion,
                municipality: municipality
            )
        case .cityRegions:
            if let searchItem = getInputFieldConfigData(type: .town) as? SearchItem,
               let town = searchItem.data as? Town
            {
                viewController.viewModel.loadCityRegions(town.cityRegions)
            }
        case .sections:
            guard
                let townItem = getInputFieldConfigData(type: .town) as? SearchItem,
                let town = townItem.data as? Town
            else {
                return
            }
            
            let cityRegionItem = getInputFieldConfigData(type: .cityRegion) as? SearchItem
            let cityRegion = cityRegionItem?.data as? CityRegion
            
            viewController.viewModel.getSections(town: town, cityRegion: cityRegion)
        default:
            break
        }
        
        let navController = UINavigationController(rootViewController: viewController)
        self.present(navController, animated: true)
    }
}

// MARK: - SearchViewControllerDelegate

extension SendViolationViewController: SearchViewControllerDelegate {
    
    func didFinishSearching(value: SearchItem?, sender: SearchViewController) {
        if let indexPath = sender.parentCellIndexPath {
            viewModel.updateFieldValue(value as AnyObject, at: indexPath)
        }
        
        tableView.reloadData()
        sender.dismiss(animated: true, completion: nil)
    }
}
