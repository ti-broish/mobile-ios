//
//  GetViolationsRequest.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 27.04.21.
//

import Foundation

struct GetViolationsRequest: RequestProvider {
    
    var path: String {
        "/me/violations"
    }
    
}
