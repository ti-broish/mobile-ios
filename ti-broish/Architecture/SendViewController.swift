//
//  SendViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 6.07.21.
//

import UIKit
import Photos

class SendViewController: BaseTableViewController {
    
    @objc func handlePhotoGalleryButton(_ sender: UIButton) {
        forceResignFirstResponder()
        
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
        forceResignFirstResponder()
        
        let controller = UIImagePickerController()
        controller.sourceType = .camera
        controller.delegate = self
        present(controller, animated: true)
    }
    
    func updateSelectedImages(_ images: [UIImage]) {
        assertionFailure("updateSelectedImages not implemented")
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

// MARK: - PhotosPickerDelegate

extension SendViewController: PhotosPickerDelegate {
    
    func didSelectPhotos(_ photos: [UIImage], sender: PhotosPickerViewController) {
        print("didSelectPhotos: \(photos)")
        updateSelectedImages(photos)
        sender.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension SendViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true)

        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }

        updateSelectedImages([image])
    }
}
