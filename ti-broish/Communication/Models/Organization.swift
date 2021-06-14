//
//  Organization.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 7.05.21.
//

import Foundation

enum OrganizationType: String, Codable {
    
    case party = "party"
    case commission = "commission"
    case watchers = "watchers"
}

typealias OrganizationsResponse = [Organization]

struct Organization: Codable {
    
    let id: Int
    let name: String
    //let type: OrganizationType
    
    func toDictionary() -> [String: Any?] {
        return [ "id": id, "name": name ]
    }
}
