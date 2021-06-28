//
//  SendViolationViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 23.04.21.
//

import UIKit
import Combine

final class SendViolationViewController: BaseTableViewController {
    
    private let viewModel = SendViolationViewModel()
    private var sendSubscription: AnyCancellable?
    
    private var isAbroad: Bool = false {
        didSet {
            viewModel.reloadDataFields(isAbroad: isAbroad)
        }
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObservers()
        viewModel.start()
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
    
    override func updateTextInputFieldValue(_ value: AnyObject?, at indexPath: IndexPath) {
        viewModel.updateFieldValue(value, at: indexPath)
    }
    
    override func updateSelectedImages(_ images: [UIImage]) {
        viewModel.setImages(images)
        tableView.reloadData()
    }
    
    override func handleSendButton(_ sender: UIButton) {
        let dataFields: [SendFieldType] = isAbroad
            ? [.countries, .town, .description]
            : [.electionRegion, .municipality, .town, .description]
        
        var message: String? = nil
        
        for field in dataFields {
            if let errorMessage = errorMessageForField(type: field) {
                message = errorMessage
                break
            }
        }
        
        if let message = message {
            view.showMessage(message)
        } else {
            viewModel.trySendViolation()
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
    
    private func errorMessageForField(type: SendFieldType) -> String? {
        guard let data = viewModel.dataForField(type: type) else {
            switch type {
            case .countries:
                return LocalizedStrings.SendInputField.countryNotSet
            case .electionRegion:
                return LocalizedStrings.SendInputField.electionRegionNotSet
            case .municipality:
                return LocalizedStrings.SendInputField.municipalityNotSet
            case .town:
                return LocalizedStrings.SendInputField.townNotSet
            case .description:
                return LocalizedStrings.SendInputField.descriptionNotSet
            default:
                return LocalizedStrings.Errors.defaultError
            }
        }
        
        if type == .town,
           let town = data as? Town,
           let cityRegions = town.cityRegions
        {
            if cityRegions.count > 0 && viewModel.dataForField(type: .cityRegion) == nil {
                return LocalizedStrings.SendInputField.cityRegionNotSet
            }
        } else if type == .description {
            if let desc = data as? String, desc.count >= 20 {
                return nil
            } else {
                return LocalizedStrings.SendInputField.descriptionNotSet
            }
        }
        
        return nil
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
        return SendSectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = SendSectionType(rawValue: section)
        
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
        let section = SendSectionType(rawValue: indexPath.section)
        
        switch section {
        case .data:
            let model = viewModel.data[indexPath.row]
            let cell: UITableViewCell
            
            if model.isTextField {
                let fieldType = model.dataType as! SendFieldType
                
                if fieldType == .description {
                    let reusableCell = tableView.dequeueReusableCell(
                        withIdentifier: DescriptionCell.cellIdentifier,
                        for: indexPath
                    )
                    
                    guard let descriptionCell = reusableCell as? DescriptionCell  else {
                        return UITableViewCell()
                    }

                    descriptionCell.configureWith(model)
                    descriptionCell.textView.delegate = self
                    cell = descriptionCell
                } else {
                    let reusableCell = tableView.dequeueReusableCell(withIdentifier: TextCell.cellIdentifier, for: indexPath)
                    guard let textCell = reusableCell as? TextCell  else {
                        return UITableViewCell()
                    }

                    textCell.configureWith(model)
                    textCell.textInputField.textField.delegate = self
                    
                    cell = textCell
                }
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
            
            photoButtonsCell.hideMessage()
            photoButtonsCell.galleryButton.addTarget(self, action: #selector(handlePhotoGalleryButton), for: .touchUpInside)
            photoButtonsCell.cameraButton.addTarget(self, action: #selector(handleCameraButton), for: .touchUpInside)
            
            return photoButtonsCell
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - Private methods
    
    @objc private func handleDeleteImage(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: SendSectionType.images.rawValue)
        
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
        let data = viewModel.data[indexPath.row]
        
        if data.isPickerField && shouldShowSearchController(for: indexPath) {
            showSearchController(for: indexPath)
        }
    }
    
    // MARK: - Private methods (UITableViewDelegate)
    
    private func shouldShowSearchController(for indexPath: IndexPath) -> Bool {
        guard let fieldType = viewModel.data[indexPath.row].dataType as? SendFieldType else {
            return false
        }
        
        switch fieldType {
        case .municipality:
            if let _ = viewModel.dataForField(type: .electionRegion) {
                return true
            } else {
                view.showMessage(LocalizedStrings.SendInputField.electionRegionNotSet)
                return false
            }
        case .town:
            if let _ = viewModel.dataForField(type: isAbroad ? .countries : .municipality) {
                return true
            } else {
                if isAbroad {
                    view.showMessage(LocalizedStrings.SendInputField.countryNotSet)
                } else {
                    view.showMessage(LocalizedStrings.SendInputField.municipalityNotSet)
                }
                return false
            }
        case .section:
            if let town = viewModel.dataForField(type: .town) as? Town {
                let cityRegionsCount = town.cityRegions?.count ?? 0
                
                if  cityRegionsCount > 0 {
                    if let _ = viewModel.dataForField(type: .cityRegion) {
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
    
    private func loadData(searchController: SearchViewController) {
        switch searchController.viewModel.searchType {
        case .municipalities:
            if let electionRegion = viewModel.dataForField(type: .electionRegion) as? ElectionRegion {
                searchController.viewModel.loadMunicipalities(electionRegion.municipalities)
            }
        case .towns:
            let electionRegion = viewModel.dataForField(type: .electionRegion) as? ElectionRegion
            let country = viewModel.dataForField(type: .countries) as? Country ?? Country.defaultCountry
            let municipality = viewModel.dataForField(type: .municipality) as? Municipality
            
            searchController.viewModel.getTowns(
                country: country,
                electionRegion: electionRegion,
                municipality: municipality
            )
        case .cityRegions:
            if let town = viewModel.dataForField(type: .town) as? Town,
               let cityRegions = town.cityRegions
            {
                searchController.viewModel.loadCityRegions(cityRegions)
            }
        case .sections:
            guard let town = viewModel.dataForField(type: .town) as? Town else {
                return
            }
            
            let cityRegion = viewModel.dataForField(type: .cityRegion) as? CityRegion
            
            searchController.viewModel.getSections(town: town, cityRegion: cityRegion)
        default:
            break
        }
    }
    
    private func showSearchController(for indexPath: IndexPath) {
        let viewController = SearchViewController.init(nibName: SearchViewController.nibName, bundle: nil)
        let searchType = viewModel.getSearchType(for: indexPath)
        viewController.viewModel.setSearchType(searchType, isAbroad: isAbroad)
        viewController.delegate = self
        viewController.parentCellIndexPath = indexPath
        viewController.selectedItem = viewModel.data[indexPath.row].data as? SearchItem
        loadData(searchController: viewController)
        
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

// MARK: - CountryCellDelegate

extension SendViolationViewController: CountryCellDelegate {
    
    func didChangeCountryType(_ type: CountryType, sender: CountryCell) {
        isAbroad = type == .abroad
        
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension SendViolationViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if viewModel.dataForField(type: .description) == nil {
            textView.textColor = TibTheme().textColor
            textView.text = ""
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            
            if let index = viewModel.indexForField(type: .description) {
                let indexPath = IndexPath(row: index, section: SendSectionType.data.rawValue)
                viewModel.updateFieldValue(textView.text as AnyObject, at: indexPath)
            }
        }
        
        return true
    }
}
