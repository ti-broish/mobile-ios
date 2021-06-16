//
//  BaseTableViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 16.06.21.
//

import UIKit

class BaseTableViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
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
    
    func addSendButtonAsTableFooterView() -> UIView {
        let theme = TibTheme()
        let bounds = UIScreen.main.bounds
        let container = UIView(frame: CGRect(x: 0.0, y: 0.0, width: bounds.size.width, height: bounds.size.height * 0.2))
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
    
    @objc func handleGalleryButton(_ sender: UIButton) {
        assertionFailure("handleGalleryButton not implemented")
    }
    
    @objc func handleCameraButton(_ sender: UIButton) {
        assertionFailure("handleCameraButton not implemented")
    }
    
    func addPhotoButtonsAsSectionFooterView() -> UIView {
        let theme = TibTheme()        
        let galleryButton = UIButton(type: .custom)
        galleryButton.translatesAutoresizingMaskIntoConstraints = false
        galleryButton.configureSolidButton(title: LocalizedStrings.Buttons.gallery, theme: theme)
        galleryButton.addTarget(self, action: #selector(handleGalleryButton), for: .touchUpInside)
        
        let cameraButton = UIButton(type: .custom)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.configureSolidButton(title: LocalizedStrings.Buttons.camera, theme: theme)
        cameraButton.addTarget(self, action: #selector(handleCameraButton), for: .touchUpInside)
        
        let bounds = UIScreen.main.bounds
        let container = UIView(frame: CGRect(x: 0.0, y: 0.0, width: bounds.size.width, height: 1.0))
        container.backgroundColor = theme.backgroundColor
        
        let stackView = UIStackView(arrangedSubviews: [galleryButton, cameraButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16.0
        container.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            galleryButton.widthAnchor.constraint(equalToConstant: bounds.size.width * 0.35),
            cameraButton.widthAnchor.constraint(equalToConstant: bounds.size.width * 0.35),
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 8.0),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8.0),
            stackView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
        ])
        
        return container
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
