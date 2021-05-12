//
//  UserDetails.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 12.05.21.
//

import Foundation

struct UserDetails: Codable {
    
    // MARK: Properties
    
    let firstName: String
    let lastName: String
    let email: String
    let phone: String
    let pin: String
    let hasAgreedToKeepData: Bool
    
    let organization: Organization?
    
}
