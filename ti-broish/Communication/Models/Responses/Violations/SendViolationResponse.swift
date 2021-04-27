//
//  SendViolationResponse.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 27.04.21.
//

import Foundation

struct SendViolationResponse: Decodable {
    
    let id: Int
    let section: Section
    let pictures: [UploadPhoto]
    let description: String
    let status: ViolationStatus
    
}
