//
//  Party.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 28.04.21.
//

import Foundation

typealias PartiesResponse = [Party]

struct Party: Decodable {
    
    // MARK: Properties
    
    let id: Int
    let name: String
    let displayName: String
    let isFeatured: Bool
    
}
