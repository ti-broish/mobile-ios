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
    let uploadPhotoPublisher = PassthroughSubject<APIError?, Never>()
    
    var canSend: Bool {
        return images.count == uploadPhotos.count
    }
    
    func setImages(_ images: [UIImage]) {
        for image in images {
            self.images.append(image)
            uploadImage(image)
        }
    }
    
    func removeImage(at index: Int) {
        guard index < images.count else {
            return
        }
        
        uploadPhotos.remove(at: index)
        images.remove(at: index)
    }
    
    // MARK: - Private methods
    
    private func uploadImage(_ image: UIImage) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                let base64String = imageData.base64EncodedString()
                let photo = Photo(base64: base64String)
                
                APIManager.shared.uploadPhoto(photo) { result in
                    switch result {
                    case .success(let uploadPhoto):
                        DispatchQueue.main.async {
                            print("upload photo: \(uploadPhoto)")
                            strongSelf.uploadPhotos.append(uploadPhoto)
                            strongSelf.uploadPhotoPublisher.send(nil)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            print("failed to upload photo: \(error)")
                            strongSelf.uploadPhotos.removeAll()
                            strongSelf.uploadPhotoPublisher.send(error)
                        }
                    }
                }
            }
        }
    }
}
