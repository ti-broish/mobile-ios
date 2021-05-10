//
//  GetCountriesRequest.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 28.04.21.
//

import Foundation

struct GetCountriesRequest: RequestProvider {
    
    // MARK: - RequestProvider
    
    var path: String {
        "/countries"
    }
    
}
