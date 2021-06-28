//
//  SendViolationViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 21.06.21.
//

import UIKit

final class SendViolationViewModel: BaseViewModel, CoordinatableViewModel {
    
    private (set) var images = [UIImage]()
    private var uploadPhotos = [UploadPhoto]()
    
    override func updateFieldValue(_ value: AnyObject?, at indexPath: IndexPath) {
        guard
            let fieldType = data[indexPath.row].dataType as? SendFieldType,
            let index = indexForField(type: fieldType)
        else {
            return
        }
        
        resetFieldsData(for: fieldType)
        setFieldValue(value, forFieldAt: index)
        toggleCityRegionField()
        prefillFieldValue(for: fieldType, value: value)
    }
    
    override func loadDataFields() {
        if isAbroad {
            resetAndReload(fields: SendFieldType.violationAbroadFields)
        } else {
            resetAndReload(fields: SendFieldType.violationFields)
        }
    }
    
    override func resetAll() {
        super.resetAll()
        
        uploadPhotos.removeAll()
        images.removeAll()
    }
    
    func setImages(_ images: [UIImage]) {
        images.forEach { image in
            if self.images.first(where: { $0 == image }) == nil {
                self.images.append(image)
            }
        }
    }
    
    func removeImage(at index: Int) {
        images.remove(at: index)
    }
    
    func start() {
        loadDataFields()
    }
    
    func trySendViolation() {
        if images.count > 0 {
            uploadImages()
        } else {
            loadingPublisher.send(true)
            sendViolation()
        }
    }
    
    // MARK: - Private methods
    
    private func sendViolation() {
        guard
            let town = dataForField(type: .town) as? Town,
            let descriptionText = dataForField(type: .description) as? String
        else {
            return
        }
        
        let pictures = uploadPhotos.map { $0.id }
        let section = dataForField(type: .section) as? Section
        
        APIManager.shared.sendViolation(
            town: town,
            pictures: pictures,
            description: descriptionText,
            section: section
        ) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let violation):
                print("violation sent: \(violation)")
                strongSelf.resetAll()
                strongSelf.sendPublisher.send(nil)
            case .failure(let error):
                strongSelf.uploadPhotos.removeAll()
                strongSelf.sendPublisher.send(error)
            }
        }
    }
    
    private func uploadImages() {
        loadingPublisher.send(true)
        images.forEach { [weak self] image in
            guard let strongSelf = self else {
                return
            }
            
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                let base64String = imageData.base64EncodedString()
                let photo = Photo(base64: base64String)
                
                APIManager.shared.uploadPhoto(photo) { result in
                    switch result {
                    case .success(let uploadPhoto):
                        print("upload photo: \(uploadPhoto)")
                        strongSelf.uploadPhotos.append(uploadPhoto)
                        
                        if strongSelf.uploadPhotos.count == strongSelf.images.count {
                            strongSelf.sendViolation()
                        }
                    case .failure(let error):
                        print("failed to upload photo: \(error)")
                        strongSelf.uploadPhotos.removeAll()
                        strongSelf.sendPublisher.send(error)
                    }
                }
            }
        }
    }
}
