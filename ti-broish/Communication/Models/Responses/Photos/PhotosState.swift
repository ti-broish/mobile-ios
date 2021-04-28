//
//  PhotosState.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 27.04.21.
//

import Foundation

struct PhotosState: Codable {
    
    // MARK: Properties
    
    let photos: [Photo]
    let uploadPhotos: [UploadPhoto]
    
}
