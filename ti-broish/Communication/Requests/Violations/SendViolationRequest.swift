//
//  SendViolationRequest.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 27.04.21.
//

import Foundation

struct SendViolationRequest: RequestProvider {
    
    // MARK: - Properties
    
    let town: Town
    let pictures: [String]
    let description: String
    let section: Section?
    
    // MARK: - RequestProvider
    
    var token: String
    
    var path: String {
        "/violations"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: [String : Any?] {
        [
            "town": town.id,
            "pictures": pictures,
            "description": description,
            "section": section?.id,
        ]
    }
    
}
