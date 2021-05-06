//
//  GetProtocolRequest.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 28.04.21.
//

import Foundation

struct GetProtocolRequest: RequestProvider {
    
    // MARK: - RequestProvider
    
    var token: String
    
    var path: String {
        "/me/protocols"
    }
}
