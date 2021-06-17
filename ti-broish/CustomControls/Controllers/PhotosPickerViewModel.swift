//
//  PhotosPickerViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 18.06.21.
//

import UIKit
import Photos
import Combine

final class PhotosPickerViewModel: BaseViewModel, CoordinatableViewModel {
    
    private (set) var allPhotos = PHFetchResult<PHAsset>()
    private (set) var selectedPhotos = [UIImage]()
    
    let selectedPhotosCountPublisher = PassthroughSubject<Int, Never>()
    
    func start() {
        getAllPhotos()
    }
    
    func hasPhoto(_ photo: UIImage) -> Bool {
        return selectedPhotos.firstIndex(where: { $0 == photo }) != nil
    }
    
    func selectPhoto(_ photo: UIImage) {
        selectedPhotos.append(photo)
        selectedPhotosCountPublisher.send(selectedPhotos.count)
    }
    
    func deselectPhoto(_ photo: UIImage) {
        guard let index = selectedPhotos.firstIndex(where: { $0 == photo }) else {
            return
        }
        
        selectedPhotos.remove(at: index)
        selectedPhotosCountPublisher.send(selectedPhotos.count)
    }
    // MARK: - Private methods
    
    private func getAllPhotos() {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        // TODO: - implement some pagination (batch)
        reloadDataPublisher.send()
    }
}

