//
//  APNSTokenRequest.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 27.04.21.
//

import Foundation

struct APNSTokenRequest: RequestProvider {
    
    var path: String {
        "/me/clients"
    }
    
    // TODO: - refactor firebase APN token is different from user.getIDToken
//    var parameters: [String : Any?] {
//        ["token": token]
//    }
    
}
