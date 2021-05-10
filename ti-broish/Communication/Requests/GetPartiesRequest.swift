//
//  GetPartiesRequest.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 28.04.21.
//

import Foundation

struct GetPartiesRequest: RequestProvider {
    
    // MARK: - RequestProvider
    
    var path: String {
        "/parties"
    }
    
}
