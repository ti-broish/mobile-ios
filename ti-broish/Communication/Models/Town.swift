//
//  Town.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 27.04.21.
//

import Foundation

struct Region {
    
    // MARK: Properties
    
    let code: String
    let name: String
    
}

struct Town {
    
    // MARK: Properties
    
    let id: Int
    let code: Int
    let name: String
    let cityRegions: Region?
    
}
