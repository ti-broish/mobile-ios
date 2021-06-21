//
//  GetSectionsRequest.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 28.04.21.
//

import Foundation

struct GetSectionsRequest: RequestProvider {
    
    // MARK: Properites
    
    let town: Town
    let cityRegion: CityRegion?
    
    // MARK: - RequestProvider
    
    var path: String {
        "/sections"
    }
    
    var parameters: [String : Any?] {
        if let cityRegion = cityRegion {
            return [ "town": town.id, "city_region": cityRegion.code ]
        } else {
            return [ "town": town.id ]
        }
    }
    
}
