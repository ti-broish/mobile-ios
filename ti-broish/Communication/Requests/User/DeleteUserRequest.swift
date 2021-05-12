//
//  DeleteUserRequest.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 12.05.21.
//

import Foundation

struct DeleteUserRequest: RequestProvider {
    
    // MARK: - RequestProvider
    
    var path: String {
        "/me"
    }
    
    var method: HTTPMethod {
        .delete
    }
    
}
