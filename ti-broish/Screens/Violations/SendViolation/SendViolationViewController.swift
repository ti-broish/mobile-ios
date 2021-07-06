//
//  SendViolationViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 23.04.21.
//

import UIKit

final class SendViolationViewController: SendViewController {
    
    private let viewModel = SendViolationViewModel()
    
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
        let dataFields: [SendFieldType] = viewModel.isAbroad
            ? [.countries, .town, .description]
            : [.electionRegion, .municipality, .town, .description]
        
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

                countryCell.configure(countryType: viewModel.isAbroad ? .abroad : .defaultCountry)
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
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension SendViolationViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if viewModel.dataForSendField(type: .description) == nil {
            textView.textColor = TibTheme().textColor
            textView.text = ""
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            
            if let index = viewModel.indexForSendField(type: .description) {
                let indexPath = IndexPath(row: index, section: SendSectionType.data.rawValue)
                viewModel.updateFieldValue(textView.text as AnyObject, at: indexPath)
            }
        }
        
        return true
    }
}
