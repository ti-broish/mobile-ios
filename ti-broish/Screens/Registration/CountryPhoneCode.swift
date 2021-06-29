//
//  CountryPhoneCode.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 29.06.21.
//

import Foundation

struct CountryPhoneCode: Decodable {
    
    let code: String
    let name: String
    
    static let defaultCountryPhoneCode = CountryPhoneCode(code: "+359", name: "Bulgaria")
}

struct CountryCodes: Decodable {
    
    let countries: [CountryPhoneCode]
}
