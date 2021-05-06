//
//  OrganizationsRequest.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 7.05.21.
//

import Foundation

struct OrganizationsRequest: RequestProvider {
    
    var token: String = ""
    
    var path: String {
        "/organizations"
    }
}
