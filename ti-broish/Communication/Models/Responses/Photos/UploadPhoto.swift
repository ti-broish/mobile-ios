//
//  UploadPhoto.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 27.04.21.
//

import Foundation

struct UploadPhoto: Codable {
    
    let id: String
    let url: String
    let path: String
    let sortPosition: Int
    let index: Int
    
}
