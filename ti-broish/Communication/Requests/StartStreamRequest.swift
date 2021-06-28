//
//  StartStreamRequest.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 28.06.21.
//

import Foundation

struct StartStreamRequest: RequestProvider {
    
    // MARK: - Properites
    
    let section: Section
    
    // MARK: - RequestProvider
    
    var path: String {
        "/streams"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: [String : Any?] {
        [
            "section" : section.id
        ]
    }
    
}
