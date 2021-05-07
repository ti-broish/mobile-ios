//
//  GetTownsRequest.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 28.04.21.
//

import Foundation

struct GetTownsRequest: RequestProvider {
    
    // MARK: - Properites
    
    let country: Country
    let electionRegion: ElectionRegion?
    let municipality: Municipality?
    
    // MARK: - RequestProvider
    
    var path: String {
        "/towns"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: [String : Any?] {
        [
            "country": country.code,
            "election_region": electionRegion?.code,
            "municipality": municipality?.code
        ]
    }
    
}
