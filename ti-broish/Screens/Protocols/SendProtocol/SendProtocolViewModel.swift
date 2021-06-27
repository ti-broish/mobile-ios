//
//  SendProtocolViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 15.06.21.
//

import UIKit

final class SendProtocolViewModel: BaseViewModel, CoordinatableViewModel {
    
    private (set) var images = [UIImage]()
    private var uploadPhotos = [UploadPhoto]()
    
    override func loadDataFields() {
        let builder = SendProtocolDataBuilder()
        
        SendFieldType.protocolFields.forEach {
            if let config = builder.makeConfig(for: $0) {
                data.append(config)
            }
        }
    }
    
    override func updateFieldValue(_ value: AnyObject?, at indexPath: IndexPath) {
        guard
            let fieldType = data[indexPath.row].dataType as? SendFieldType,
            let index = indexForField(type: fieldType)
        else {
            return
        }
        
        setFieldValue(value, forFieldAt: index)
    }
    
    func setImages(_ images: [UIImage]) {
        images.forEach { image in
            if self.images.first(where: { $0 == image }) == nil {
                self.images.append(image)
            }
        }
    }
    
    func removeImage(at index: Int) {
        guard index < images.count else {
            return
        }
        
        images.remove(at: index)
    }
    
    func start() {
        loadDataFields()
    }
    
    func uploadImages(section: Section) {
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
                            strongSelf.sendProtocol(section: section)
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
    
    // MARK: - Private methods
    
    private func resetData() {
        if let index = indexForField(type: .section) {
            setFieldValue(nil, forFieldAt: index)
        }
        
        uploadPhotos.removeAll()
        images.removeAll()
    }
    
    private func sendProtocol(section: Section) {
        let pictures = uploadPhotos.map { $0.id }
        APIManager.shared.sendProtocol(section: section, pictures: pictures) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let item):
                print("protocol sent: \(item)")
                strongSelf.resetData()
                strongSelf.sendPublisher.send(nil)
                strongSelf.loadingPublisher.send(false)
            case .failure(let error):
                strongSelf.uploadPhotos.removeAll()
                strongSelf.sendPublisher.send(error)
            }
        }
    }
}

