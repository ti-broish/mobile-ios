//
//  SendProtocolViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 23.04.21.
//

import UIKit

final class SendProtocolViewController: BaseTableViewController {
    
    private let viewModel = SendProtocolViewModel()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.start()
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

extension SendProtocolViewController: UITableViewDataSource {
    
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
            let reusableCell = tableView.dequeueReusableCell(withIdentifier: TextCell.cellIdentifier, for: indexPath)
            
            guard let textCell = reusableCell as? TextCell else {
                return UITableViewCell()
            }
            
            textCell.textInputField.configureWith(viewModel.data[indexPath.row])
            textCell.textInputField.textField.delegate = self
            
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
        let indexPath = IndexPath(row: sender.tag, section: SendSectionFieldType.images.rawValue)
        
        guard let _ = tableView.cellForRow(at: indexPath) as? UploadImageCell else {
            return
        }
        
        viewModel.removeImage(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - UITableViewDelegate

extension SendProtocolViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //showDetails(protocolItem: viewModel.protocols[indexPath.row])
    }
    
    // MARK: - Private methods (UITableViewDelegate)
    
//    private func showDetails(protocolItem: Protocol) {
//        let viewController = DetailsViewController.init(nibName: DetailsViewController.nibName, bundle: nil)
//        viewController.viewModel.protocolItem = protocolItem
//
//        navigationController?.pushViewController(viewController, animated: true)
//    }
}
