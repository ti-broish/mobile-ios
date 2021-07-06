//
//  SendCheckinRequest.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 6.07.21.
//

import Foundation

struct SendCheckinRequest: RequestProvider {
    
    // MARK: - Properites
    
    let section: Section
    
    // MARK: - RequestProvider
    
    var path: String {
        "/me/checkins"
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
