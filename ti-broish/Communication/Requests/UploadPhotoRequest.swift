//
//  UploadPhotoRequest.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 28.04.21.
//

import Foundation

struct UploadPhotoRequest: RequestProvider {
    
    // MARK: - Properites
    
    let photo: Photo
    
    // MARK: - RequestProvider
    
    var path: String {
        "/pictures"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: [String : Any?] {
        [
            "image": photo.data
        ]
    }
    
}
