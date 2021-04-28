//
//  Photo.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 27.04.21.
//

import Foundation

struct Photo: Codable {
    
    // MARK: Properties
    
    let filename: String
    let filepath: String
    let webviewPath: String?
    let data: String
    let isSelected: Bool
    let index: Int
    
}
