//
//  User.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 12.05.21.
//

import Foundation

struct User: Codable {
    
    // MARK: Properites
    
    let firebaseUid: String
    let userDetails: UserDetails
    
}
