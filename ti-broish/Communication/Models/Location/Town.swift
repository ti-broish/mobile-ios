//
//  Town.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 27.04.21.
//

import Foundation

typealias TownsResponse = [Town]

struct Town: Decodable {
    
    // MARK: Properties
    
    let id: Int
    let name: String
    let cityRegions: [CityRegion]
    
}
