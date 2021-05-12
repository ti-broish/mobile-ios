//
//  ElectionRegion.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 28.04.21.
//

import Foundation

typealias ElectionRegionsResponse = [ElectionRegion]

struct ElectionRegion: Decodable {
    
    // MARK: - Properties
    
    let code: String
    let name: String
    let isAbroad: Bool
    let municipalities: [Municipality]
    
}
