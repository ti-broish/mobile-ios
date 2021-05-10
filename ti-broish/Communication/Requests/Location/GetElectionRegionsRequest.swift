//
//  GetElectionRegionsRequest.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 28.04.21.
//

import Foundation

struct GetElectionRegionsRequest: RequestProvider {
    
    // MARK: - RequestProvider
    
    var path: String {
        "/election_regions"
    }
    
}
