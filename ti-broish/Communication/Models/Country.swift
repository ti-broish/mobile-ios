//
//  Country.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 7.05.21.
//

import Foundation

struct Country: Decodable {
    
    let code: String
    let name: String
    let isAbroad: Bool
}
