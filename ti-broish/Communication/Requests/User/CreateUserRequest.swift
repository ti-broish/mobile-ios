//
//  CreateUserRequest.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 12.05.21.
//

import Foundation

struct CreateUserRequest: RequestProvider {
    
    // MARK: - Properites
    
    let user: User
    
    // MARK: - RequestProvider
    
    var path: String {
        "/users"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: [String : Any?] {
        [
            "firstName": user.userDetails.firstName,
            "lastName": user.userDetails.lastName,
            "email": user.userDetails.email,
            "phone": user.userDetails.phone,
            "pin": user.userDetails.pin,
            "organization": user.userDetails.organization?.toDictionary() ?? nil,
            "firebaseUid": user.firebaseUid,
            "hasAgreedToKeepData": user.userDetails.hasAgreedToKeepData
        ]
    }
    
}
