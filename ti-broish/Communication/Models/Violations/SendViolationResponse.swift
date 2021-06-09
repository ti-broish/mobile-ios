//
//  SendViolationResponse.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 27.04.21.
//

import Foundation

struct SendViolationResponse: Decodable {
    
    // MARK: Properties
    
    let id: String
    let section: Section?
    let pictures: [Picture]
    let description: String
    let status: ViolationStatus
    
}
