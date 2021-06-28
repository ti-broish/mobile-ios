//
//  StreamResponse.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 28.06.21.
//

import Foundation

struct StreamResponse: Codable {
    
    let id: String
    let section: Section
    let streamUrl: String
    let viewUrl: String
}
