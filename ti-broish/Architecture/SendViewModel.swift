//
//  SendViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 5.07.21.
//

import UIKit
import Combine

class SendViewModel: BaseViewModel {
    
    var images = [UIImage]()
    var uploadPhotos = [UploadPhoto]()
    
    let sendPublisher = PassthroughSubject<APIError?, Never>()
    let checkinUtils = CheckinUtils()
    
    func setImages(_ images: [UIImage]) {
        for image in images {
            self.images.append(image)
        }
    }
    
    func removeImage(at index: Int) {
        guard index < images.count else {
            return
        }
        
        if index < uploadPhotos.count {
            uploadPhotos.remove(at: index)
        }
        
        images.remove(at: index)
    }
    
    func uploadImages(completion: @escaping (Result<Void, APIError>) -> (Void)) {
        loadingPublisher.send(true)
        
        if uploadPhotos.count == images.count {
            completion(.success(()))
        } else {
            uploadPhotos.removeAll()
            
            images.forEach { [weak self] image in
                guard let strongSelf = self else {
                    return
                }
                
                if let imageData = image.jpegData(compressionQuality: 0.5) {
                    let base64String = imageData.base64EncodedString()
                    let photo = Photo(base64: base64String)
                    
                    APIManager.shared.uploadPhoto(photo) { result in
                        switch result {
                        case .success(let uploadPhoto):
                            strongSelf.uploadPhotos.append(uploadPhoto)
                            
                            if strongSelf.uploadPhotos.count == strongSelf.images.count {
                                completion(.success(()))
                            }
                        case .failure(let error):
                            strongSelf.uploadPhotos.removeAll()
                            completion(.failure(error))
                        }
                    }
                }
            }
        }
    }

    func tryLoadCheckinData(fields: [SendFieldType]) {
        let checkinData = checkinUtils.getStoredCheckinData()
        
        if isAbroad {
            guard checkinData[.countries] != nil else {
                return
            }
            
            loadCheckinData(checkinData, fields: fields)
        } else {
            guard checkinData[.countries] == nil else {
                return
            }
            
            loadCheckinData(checkinData, fields: fields)
        }
    }
    
    // MARK: - Private methods
    
    private func loadCheckinData(_ checkinData: [SendFieldType: AnyObject?], fields: [SendFieldType]) {
        for field in fields {
            if let index = indexForSendField(type: field) {
                if let value = checkinData[field] {
                    resetFieldsData(for: field)
                    setFieldValue(value, forFieldAt: index)
                    toggleCityRegionField()
                    prefillFieldValue(for: field, value: value)
                }
            }
        }
    }
}
