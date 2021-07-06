//
//  SendProtocolViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 23.04.21.
//

import UIKit

final class SendProtocolViewController: SendViewController {
    
    private let viewModel = SendProtocolViewModel()
    private var section: Section?
    
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
        tableView.registerCell(TextCell.self)
        tableView.registerCell(UploadImageCell.self)
        tableView.registerCell(PhotoButtonsCell.self)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.setHeaderView(text: LocalizedStrings.Menu.sendProtocol)
        tableView.tableFooterView = sendButtonTableFooterView()
    }
    
    override func updateTextInputFieldValue(_ value: AnyObject?, at indexPath: IndexPath) {
        guard let sectionId = value as? String, sectionId.count == 9 else {
            return
        }
        
        let section = Section(id: sectionId, code: "", place: "")
        viewModel.updateFieldValue(section as AnyObject, at: indexPath)
    }
    
    override func updateSelectedImages(_ images: [UIImage]) {
        viewModel.setImages(images)
        tableView.reloadData()
    }
    
    override func handleSendButton(_ sender: UIButton) {
        guard
            let index = viewModel.indexForSendField(type: .section),
            let section = viewModel.data[index].data as? Section,
            section.id.count > 8
        else {
            view.showMessage(LocalizedStrings.Errors.invalidSection)
            return
        }
        
        guard viewModel.images.count > 3 else {
            view.showMessage(LocalizedStrings.Errors.invalidPhotos)
            return
        }

        viewModel.uploadImages(section: section)
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
                        case .requestFailed(let responseError):
                            view.showMessage(responseError.message.first ?? LocalizedStrings.Errors.defaultError)
                        default:
                            break
                        }
                    } else {
                        view.showMessage(LocalizedStrings.Protocols.sent)
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

extension SendProtocolViewController: UITableViewDataSource {
    
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
            let reusableCell = tableView.dequeueReusableCell(withIdentifier: TextCell.cellIdentifier, for: indexPath)
            
            guard let textCell = reusableCell as? TextCell else {
                return UITableViewCell()
            }
            
            textCell.textInputField.configureWith(viewModel.data[indexPath.row])
            textCell.textInputField.textField.delegate = self
            textCell.textInputField.textField.keyboardType = .numbersAndPunctuation
            
            return textCell
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
        let indexPath = IndexPath(row: sender.tag, section: SendSectionType.images.rawValue)
        
        guard let _ = tableView.cellForRow(at: indexPath) as? UploadImageCell else {
            return
        }
        
        viewModel.removeImage(at: indexPath.row)
        tableView.reloadData()
    }
}

// MARK: - UITextFieldDelegate

extension SendProtocolViewController {
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let newString = "\(textField.text ?? "")\(string)"

        guard
            newString.count <= 9,
            CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
        else {
            return false
        }
        
        return true
    }
}
