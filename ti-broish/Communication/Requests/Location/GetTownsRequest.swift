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
    
    var parameters: [String : Any?] {
        if let electionRegionCode = electionRegion?.code {
            if let municipalityCode = municipality?.code {
                return [
                    "country": country.code,
                    "election_region": electionRegionCode,
                    "municipality": municipalityCode
                ]
            } else {
                return ["country": country.code, "election_region": electionRegionCode]
            }
        }
        
        return ["country": country.code]
    }
}
