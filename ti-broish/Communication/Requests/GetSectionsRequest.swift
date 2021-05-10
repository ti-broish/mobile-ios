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
    let region: Region?
    
    // MARK: - RequestProvider
    
    var path: String {
        "/sections"
    }
    
    var parameters: [String : Any?] {
        [
            "town": town.id,
            "region": region?.code
        ]
    }
    
}
