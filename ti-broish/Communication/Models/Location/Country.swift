//
//  Country.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 28.04.21.
//

import Foundation

typealias CountriesResponse = [Country]

struct Country: Decodable {
    
    static var defaultCountry: Country {
        return Country(code: "00", name: "България", isAbroad: false)
    }
    
    // MARK: Properties
    
    let code: String
    let name: String
    let isAbroad: Bool
}
