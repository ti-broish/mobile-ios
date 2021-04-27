//
//  SendAPNsToken.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 27.04.21.
//

import Foundation

struct SendAPNsToken: RequestProvider {
    
    let token: String
    
    var path: String {
        "/me/clients"
    }
    
    var parameters: [String : Any] {
        ["token": token]
    }
    
}
