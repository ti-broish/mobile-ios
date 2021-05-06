//
//  SendProtocolRequest.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 28.04.21.
//

import Foundation

struct SendProtocolRequest: RequestProvider {
    
    // MARK: - Properites
    
    let section: Section
    let pictures: [String]
    
    // MARK: - RequestProvider
    
    var token: String
    
    var path: String {
        "/protocols"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: [String : Any?] {
        [
            "section" : section.id,
            "pictures" : pictures
        ]
    }
    
}
