//
//  CountriesRequest.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 7.05.21.
//

import Foundation

struct CountriesRequest: RequestProvider {
    
    var token: String
    
    var path: String {
        "/countries"
    }
}
